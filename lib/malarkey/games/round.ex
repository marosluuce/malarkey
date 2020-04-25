defmodule Malarkey.Games.Round do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__
  alias Malarkey.Games.{Game, Submission}
  alias Malarkey.Users.User

  schema "rounds" do
    field :topic, :string

    belongs_to :game, Game
    belongs_to :user, User
    has_many :submissions, Submission
    has_many :votes, through: [:submissions, :votes]

    timestamps()
  end

  def changeset(attrs) do
    %Round{}
    |> cast(attrs, [:game_id, :user_id, :topic])
    |> validate_required([:game_id, :user_id, :topic])
  end
end
