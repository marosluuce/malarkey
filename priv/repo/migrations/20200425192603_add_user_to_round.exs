defmodule Malarkey.Repo.Migrations.AddUserToRound do
  use Ecto.Migration

  def change do
    alter table(:rounds) do
      add :user_id, references(:users), null: false
    end
  end
end
