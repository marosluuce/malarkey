defmodule MalarkeyWeb.GameLive do
  use MalarkeyWeb, :live_view

  alias Phoenix.PubSub
  alias Malarkey.Games
  alias Malarkey.Games.Round
  alias MalarkeyWeb.GameView
  alias MalarkeyWeb.Credentials

  def render(assigns) do
    GameView.render("view-live.html", assigns)
  end

  def mount(%{"id" => id}, session, socket) do
    user = Credentials.get_user(socket, session)
    game = Games.find_game(id)

    socket =
      socket
      |> assign(:user, user)
      |> assign(:game, game)
      |> assign(:scores, Games.score(game))
      |> assign(:changeset, Round.changeset(%{}))

    PubSub.subscribe(Malarkey.PubSub, topic(socket))

    {:ok, socket}
  end

  def handle_event("join", _, socket) do
    Games.join(socket.assigns.user, socket.assigns.game)
    PubSub.broadcast(Malarkey.PubSub, topic(socket), :refresh)

    {:noreply, socket}
  end

  def handle_event("save", %{"round" => params}, socket) do
    %{"topic" => topic} = params
    {:ok, round} = Games.start_round(socket.assigns.game, socket.assigns.user, topic)
    PubSub.broadcast(Malarkey.PubSub, topic(socket), {:new_round, round})

    {:noreply, socket}
  end

  def handle_info({:new_round, round}, socket) do
    {:noreply,
     push_redirect(socket, to: Routes.round_path(socket, :index, round.game_id, round.id))}
  end

  def handle_info(:refresh, socket) do
    game = Games.find_game(socket.assigns.game.id)

    socket =
      socket
      |> assign(:game, game)
      |> assign(:scores, Games.score(game))

    {:noreply, socket}
  end

  defp topic(socket) do
    "game:#{socket.assigns.game.id}"
  end
end
