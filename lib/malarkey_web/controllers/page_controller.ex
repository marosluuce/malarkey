defmodule MalarkeyWeb.PageController do
  use MalarkeyWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
