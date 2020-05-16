defmodule MalarkeyWeb.Router do
  use MalarkeyWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
  end

  scope "/", MalarkeyWeb do
    pipe_through [:browser, :protected]

    live "/l", GameLive, :index

    get "/", GameController, :index
    post "/new", GameController, :new
    get "/:id", GameController, :view
    post "/:id/join", GameController, :join
    post "/:id/round/new", GameController, :new_round
    get "/:id/round/:round_id", GameController, :view_round
    post "/:id/round/:round_id", GameController, :submit
    post "/:id/round/:round_id/vote/:submission_id", GameController, :vote
  end

  # Other scopes may use custom stacks.
  # scope "/api", MalarkeyWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: MalarkeyWeb.Telemetry
    end
  end
end
