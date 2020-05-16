defmodule MalarkeyWeb.RoundLive do
  use MalarkeyWeb, :live_view

  alias Phoenix.PubSub
  alias Malarkey.Games
  alias Malarkey.Games.Submission
  alias MalarkeyWeb.GameView
  alias MalarkeyWeb.Credentials

  def render(assigns) do
    GameView.render("view_round_live.html", assigns)
  end

  def mount(params, session, socket) do
    %{"round_id" => round_id} = params
    user = Credentials.get_user(socket, session)
    round = Games.find_round(round_id)
    game = Games.find_game(round.game_id)
    has_answered = Enum.any?(round.submissions, &(&1.user_id == user.id))

    socket =
      socket
      |> assign(:user, user)
      |> assign(:round, round)
      |> assign(:game, game)
      |> assign(:scores, Games.score(game))
      |> assign(:changeset, Submission.changeset(%{}))
      |> assign(:has_answered, has_answered)

    PubSub.subscribe(Malarkey.PubSub, topic(socket))

    {:ok, socket}
  end

  def handle_event("submit_answer", %{"submission" => params}, socket) do
    %{"answer" => answer} = params
    {:ok, _} = Games.submit_answer(socket.assigns.user, socket.assigns.round, answer)
    PubSub.broadcast(Malarkey.PubSub, topic(socket), :refresh)

    {:noreply, assign(socket, :has_answered, true)}
  end

  def handle_event("vote", %{"submission" => id}, socket) do
    submission = Games.find_submission(id)
    {:ok, _} = Games.vote(socket.assigns.user, submission)
    PubSub.broadcast(Malarkey.PubSub, topic(socket), :refresh)

    {:noreply, socket}
  end

  def handle_info(:refresh, socket) do
    round = Games.find_round(socket.assigns.round.id)
    game = Games.find_game(round.game_id)

    socket =
      socket
      |> assign(:round, round)
      |> assign(:game, game)
      |> assign(:scores, Games.score(game))

    {:noreply, socket}
  end

  defp topic(socket) do
    "round:#{socket.assigns.round.id}"
  end
end
