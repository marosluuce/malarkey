defmodule Malarkey.Games.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__
  alias Malarkey.Games.Submission
  alias Malarkey.Users.User

  schema "votes" do
    belongs_to :user, User
    belongs_to :submission, Submission

    timestamps()
  end

  def changeset(attrs) do
    %Vote{}
    |> cast(attrs, [:user_id, :submission_id, :round_id])
    |> validate_required([:user_id, :submission_id, :round_id])
    |> unique_constraint([:user_id, :round_id], name: :votes_round_user_index)
  end
end
