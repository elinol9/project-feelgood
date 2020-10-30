defmodule Feelgood.Guestbook.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :name, :string
    field :text, :string

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:name, :text])
    |> validate_required([:name, :text])
  end
end
