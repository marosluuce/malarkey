defmodule Malarkey.Games do
  import Ecto.Query

  alias Malarkey.Repo
  alias Malarkey.Games.{Game, Player, Round, Submission, Vote}

  def new do
    Repo.insert(Game.new_changeset())
  end

  def all do
    Repo.all(Game)
  end

  def finish(game) do
    game
    |> Game.finish_changeset()
    |> Repo.insert()
  end

  def join(user, game) do
    %{user_id: user.id, game_id: game.id}
    |> Player.changeset()
    |> Repo.insert()
  end

  def start_round(game, user, topic) do
    %{game_id: game.id, user_id: user.id, topic: topic}
    |> Round.changeset()
    |> Repo.insert()
  end

  def latest_round(game) do
    query =
      from r in Round,
        where: r.game_id == ^game.id,
        order_by: [desc: r.id]

    Repo.one(query)
  end

  def submit_answer(user, round, answer) do
    %{user_id: user.id, round_id: round.id, answer: answer}
    |> Submission.changeset()
    |> Repo.insert()
  end

  def vote(%{id: id}, %{user_id: id}), do: {:error, :cannot_vote_for_yourself}

  def vote(user, submission) do
    %{user_id: user.id, submission_id: submission.id, round_id: submission.round_id}
    |> Vote.changeset()
    |> Repo.insert()
  end

  def score(game = %Game{}) do
    game.rounds
    |> Enum.map(&score/1)
    |> Enum.reduce(%{}, fn score, acc ->
      Map.merge(score, acc, fn _, a, b -> a + b end)
    end)
  end

  def score(round = %Round{}) do
    scores =
      Enum.reduce(round.votes, %{}, fn vote, acc ->
        acc =
          if vote.submission.user_id == round.user_id do
            Map.update(acc, vote.user_id, 1, &(&1 + 1))
          else
            Map.update(acc, vote.submission.user_id, 1, &(&1 + 1))
          end

        acc
      end)

    was_voted_for = Enum.map(round.votes, & &1.submission.user_id)

    if Enum.count(round.votes) == 0 or round.user_id in was_voted_for do
      Map.update(scores, round.user_id, 0, & &1)
    else
      Map.update(scores, round.user_id, 2, &(&1 + 2))
    end
  end

  def find_game(id) do
    Game
    |> Repo.get(id)
    |> Repo.preload([:users, [rounds: [votes: :submission]]])
  end

  def find_round(id) do
    Round
    |> Repo.get(id)
    |> Repo.preload([:submissions, votes: [:submission]])
  end

  def find_submission(id) do
    Repo.get(Submission, id)
  end
end
