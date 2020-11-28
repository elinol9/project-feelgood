defmodule Feelgood.Repo.Migrations.AddUseridToComments do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      #TODO: what will happen on_delete?
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end
  end
end
