defmodule Malarkey.Games.Player do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__
  alias Malarkey.Games.Game
  alias Malarkey.Users.User

  schema "players" do
    belongs_to :game, Game
    belongs_to :user, User

    timestamps()
  end

  def changeset(attrs) do
    %Player{}
    |> cast(attrs, [:game_id, :player_id])
    |> validate_required([:game_id, :player_id])
    |> unique_constraint([:game_id, :player_id], name: :players_game_user_index)
  end
end
