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
  end

  def changeset(attrs) do
    %Submission{}
    |> cast(attrs, [:round_id, :user_id, :answer])
    |> validate_required([:round_id, :user_id, :answer])
    |> unique_constraint([:round_id, :user_id], name: :submission_round_user_index)
  end
end
