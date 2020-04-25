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

  def start_round(game, topic) do
    %{game_id: game.id, topic: topic}
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

  def vote(user, submission) do
    %{user_id: user.id, submission_id: submission.id, round_id: submission.round_id}
    |> Vote.changeset()
    |> Repo.insert()
  end

  def find_game(id) do
    Game
    |> Repo.get(id)
    |> Repo.preload([:users, :rounds])
  end

  def find_round(id) do
    Round
    |> Repo.get(id)
    |> Repo.preload([:submissions, :votes])
  end

  def find_submission(id) do
    Repo.get(Submission, id)
  end
end
