defmodule Malarkey.Repo do
  use Ecto.Repo,
    otp_app: :malarkey,
    adapter: Ecto.Adapters.Postgres
end
