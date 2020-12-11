defmodule Feelgood.Guestbook.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :text, :string

    belongs_to :user, Feelgood.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    IO.inspect(attrs)
    comment
    |> cast(attrs, [:user_id, :text])
    |> validate_required([:user_id, :text])
    # comment
    # |> cast(attrs, [:name, :text])
    # |> validate_required([:name, :text])
  end
end
