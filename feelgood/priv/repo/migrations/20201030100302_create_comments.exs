defmodule Feelgood.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :name, :string
      add :text, :string

      timestamps()
    end

  end
end
