defmodule FeelgoodWeb.CommentController do
  use FeelgoodWeb, :controller

  alias Feelgood.Guestbook
  alias Feelgood.Guestbook.Comment

  def index(conn, _params) do
    comments = Guestbook.list_comments()
    render(conn, "index.html", comments: comments)
  end

  def new(conn, _params) do
    if conn.assigns[:current_user] do
      changeset = Guestbook.change_comment(%Comment{})
      render(conn, "new.html", changeset: changeset)
    else
      unauthorized(conn)
    end
  end

  def create(conn, %{"comment" => comment_params}) do
    if conn.assigns[:current_user] do
      case Guestbook.create_comment(conn.assigns[:current_user], comment_params) do
        {:ok, comment} ->
          conn
          |> put_flash(:info, "Comment created successfully.")
          |> redirect(to: Routes.comment_path(conn, :show, comment))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    else
      unauthorized(conn)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Guestbook.get_comment!(id)
    render(conn, "show.html", comment: comment)
  end

  def edit(conn, %{"id" => id}) do
    if conn.assigns[:current_user] do
      comment = Guestbook.get_comment!(id)
      changeset = Guestbook.change_comment(comment)
      render(conn, "edit.html", comment: comment, changeset: changeset)
    else
      unauthorized(conn)
    end
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    if conn.assigns[:current_user] do
      comment = Guestbook.get_comment!(id)

      case Guestbook.update_comment(comment, comment_params) do
        {:ok, comment} ->
          conn
          |> put_flash(:info, "Comment updated successfully.")
          |> redirect(to: Routes.comment_path(conn, :show, comment))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", comment: comment, changeset: changeset)
      end
    else
      unauthorized(conn)
    end
  end

  def delete(conn, %{"id" => id}) do
    if conn.assigns[:current_user] do
      comment = Guestbook.get_comment!(id)
      {:ok, _comment} = Guestbook.delete_comment(comment)

      conn
      |> put_flash(:info, "Comment deleted successfully.")
      |> redirect(to: Routes.comment_path(conn, :index))
    else
      unauthorized(conn)
    end
  end

  defp unauthorized(conn) do
    conn
    |> put_status(403)
    |> put_view(FeelgoodWeb.ErrorView)
    |> render(:"403")
  end
end
