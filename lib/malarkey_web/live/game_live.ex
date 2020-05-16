defmodule MalarkeyWeb.GameLive do
  use MalarkeyWeb, :live_view

  alias Phoenix.PubSub
  alias Malarkey.Games
  alias MalarkeyWeb.GameView
  alias MalarkeyWeb.Credentials

  def render(assigns) do
    GameView.render("index-live.html", assigns)
  end

  def mount(_, session, socket) do
    user = Credentials.get_user(socket, session)
    games = Games.all()

    socket =
      socket
      |> assign(:user, user)
      |> assign(:games, games)

    PubSub.subscribe(Malarkey.PubSub, topic(socket))

    {:ok, socket}
  end

  def handle_event("new_game", _, socket) do
    %{games: games} = socket.assigns
    {:ok, game} = Games.new()
    PubSub.broadcast(Malarkey.PubSub, topic(socket), :new_game)

    {:noreply, socket}
  end

  def handle_info(:new_game, socket) do
    games = Games.all()

    {:noreply, assign(socket, :games, games)}
  end

  defp topic(_) do
    "games"
  end
end
