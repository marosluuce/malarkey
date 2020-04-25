defmodule Malarkey.Repo.Migrations.AddGame do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :finished, :boolean, default: false, null: false

      timestamps()
    end

    create table(:players) do
      add :game_id, references(:games), null: false
      add :user_id, references(:users), null: false

      timestamps()
    end

    create unique_index(:players, [:game_id, :user_id], names: :players_game_user_index)

    create table(:rounds) do
      add :topic, :string, null: false
      add :game_id, references(:games), null: false

      timestamps()
    end

    create table(:submissions) do
      add :answer, :string, null: false
      add :round_id, references(:rounds), null: false
      add :user_id, references(:users), null: false

      timestamps()
    end

    create unique_index(:submissions, [:round_id, :user_id], names: :submissions_round_user_index)

    create table(:votes) do
      add :submission_id, references(:submissions), null: false
      add :round_id, references(:rounds), null: false
      add :user_id, references(:users), null: false
    end

    create unique_index(:votes, [:round_id, :user_id], names: :votes_round_user_index)
  end
end
