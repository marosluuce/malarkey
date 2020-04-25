defmodule MalarkeyWeb.GameController do
  use MalarkeyWeb, :controller

  alias MalarkeyWeb.Endpoint
  alias Malarkey.Games

  def index(conn, _) do
    games = Games.all()
    conn = assign(conn, :games, games)
    render(conn, "index.html")
  end

  def new(conn, _) do
    {:ok, game} = Games.new()

    redirect(conn, to: Routes.game_path(Endpoint, :view, game.id))
  end

  def new_round(conn, params) do
    game = find_game(params)
    {:ok, round} = Games.start_round(game, params["topic"])

    redirect(conn, to: Routes.game_path(Endpoint, :view_round, game.id, round.id))
  end

  def view(conn, params) do
    game = find_game(params)

    conn
    |> assign(:game, game)
    |> assign(:users, game.users)
    |> assign(:rounds, game.rounds)
    |> render("view.html")
  end

  def view_round(conn, params) do
    game = find_game(params)
    round = find_round(params)

    conn
    |> assign(:round, round)
    |> assign(:users, game.users)
    |> assign(:submissions, round.submissions)
    |> render("view_round.html")
  end

  def join(conn, params) do
    user = Pow.Plug.current_user(conn)
    game = find_game(params)

    Games.join(user, game)

    redirect(conn, to: Routes.game_path(Endpoint, :view, game.id))
  end

  def submit(conn, params) do
    user = Pow.Plug.current_user(conn)
    round = find_round(params)

    Games.submit_answer(user, round, params["answer"])

    redirect(conn, to: Routes.game_path(Endpoint, :view_round, round.game_id, round.id))
  end

  def vote(conn, params) do
    user = Pow.Plug.current_user(conn)
    round = find_round(params)
    submission = find_submission(params)

    Games.vote(user, submission)

    redirect(conn, to: Routes.game_path(Endpoint, :view_round, round.game_id, round.id))
  end

  defp find_game(params) do
    Games.find_game(params["id"])
  end

  defp find_round(params) do
    Games.find_round(params["round_id"])
  end

  defp find_submission(params) do
    Games.find_submission(params["submission_id"])
  end
end
