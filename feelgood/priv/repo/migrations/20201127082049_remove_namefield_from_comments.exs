defmodule Feelgood.Repo.Migrations.RemoveNamefieldFromComments do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      remove :name, :string
    end
  end
end
