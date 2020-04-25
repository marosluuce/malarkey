defmodule Malarkey.Repo.Migrations.AddTimestampsToVote do
  use Ecto.Migration

  def change do
    alter table(:votes) do
      timestamps()
    end
  end
end
