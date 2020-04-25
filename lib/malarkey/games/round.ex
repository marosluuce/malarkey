defmodule Malarkey.Games.Round do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__
  alias Malarkey.Games.Game

  schema "rounds" do
    field :topic, :string

    belongs_to :game, Game
    has_many :submissions, Submission
    has_many :votes, through: [:submissions, :votes]

    timestamps()
  end

  def changeset(attrs) do
    %Round{}
    |> cast(attrs, [:topic])
    |> validate_required([:topic])
  end
end
