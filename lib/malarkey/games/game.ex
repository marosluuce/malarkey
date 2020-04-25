defmodule Malarkey.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__
  alias Malarkey.Games.{Player, Round}

  schema "games" do
    field :finished, :boolean, default: false

    has_many :players, Player
    has_many :users, through: [:players, :user]
    has_many :rounds, Round

    timestamps()
  end

  def new_changeset() do
    cast(%Game{}, %{}, [])
  end

  def finish_changeset(game) do
    cast(game, %{finished: true}, [:finished])
  end
end
