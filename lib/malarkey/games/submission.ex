defmodule Malarkey.Games.Submission do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__
  alias Malarkey.Games.{Round, Vote}
  alias Malarkey.Users.User

  schema "submissions" do
    field :answer, :string

    belongs_to :round, Round
    belongs_to :user, User

    has_many :votes, Vote

    timestamps()
  end

  def changeset(attrs) do
    %Submission{}
    |> cast(attrs, [:round_id, :user_id, :answer])
    |> validate_required([:round_id, :user_id, :answer])
    |> unique_constraint([:round_id, :user_id], name: :submissions_round_id_user_id_index)
  end
end
