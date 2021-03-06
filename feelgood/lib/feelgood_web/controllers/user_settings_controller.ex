defmodule FeelgoodWeb.UserSettingsController do
  use FeelgoodWeb, :controller

  alias Feelgood.Accounts
  alias FeelgoodWeb.UserAuth

  plug :assign_changesets

  def edit(conn, _params) do
    render(conn, "edit.html")
  end

  # %{"_csrf_token" => "NSxLeE4AXiplRiheGBZQBiA_PHgtOyMzrVzUyc8PHve3_W1vgSX0xZIy", "_method" => "put", "user" => %{"name" => "Lars Wikman"}}

  def update_name(conn, %{"user" => %{"name" => name}}) do
    case Accounts.update_user_name(conn.assigns.current_user, name) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Name changed successfully.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      {:error, _}->
        conn
        |> put_flash(:error, "Could not change name.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))
    end
  end

  def update_email(conn, %{"current_password" => password, "user" => user_params}) do
    user = conn.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_update_email_instructions(
          applied_user,
          user.email,
          &Routes.user_settings_url(conn, :confirm_email, &1)
        )

        conn
        |> put_flash(
          :info,
          "A link to confirm your email change has been sent to the new address."
        )
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      {:error, changeset} ->
        render(conn, "edit.html", email_changeset: changeset)
    end
  end

  def confirm_email(conn, %{"token" => token}) do
    case Accounts.update_user_email(conn.assigns.current_user, token) do
      :ok ->
        conn
        |> put_flash(:info, "Email changed successfully.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      :error ->
        conn
        |> put_flash(:error, "Email change link is invalid or it has expired.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))
    end
  end

  def update_password(conn, %{"current_password" => password, "user" => user_params}) do
    user = conn.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Password updated successfully.")
        |> put_session(:user_return_to, Routes.user_settings_path(conn, :edit))
        |> UserAuth.log_in_user(user)

      {:error, changeset} ->
        render(conn, "edit.html", password_changeset: changeset)
    end
  end

  defp assign_changesets(conn, _opts) do
    user = conn.assigns.current_user

    conn
    |> assign(:email_changeset, Accounts.change_user_email(user))
    |> assign(:password_changeset, Accounts.change_user_password(user))
    |> assign(:name_changeset, Accounts.change_user_name(user))
  end
end
