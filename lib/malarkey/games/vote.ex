defmodule Malarkey.Games.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__
  alias Malarkey.Games.{Round, Submission}
  alias Malarkey.Users.User

  schema "votes" do
    belongs_to :user, User
    belongs_to :submission, Submission
    belongs_to :round, Round

    timestamps()
  end

  def changeset(attrs) do
    %Vote{}
    |> cast(attrs, [:user_id, :submission_id, :round_id])
    |> validate_required([:user_id, :submission_id, :round_id])
    |> unique_constraint([:user_id, :round_id], name: :votes_round_id_user_id_index)
  end
end
