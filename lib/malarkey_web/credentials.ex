defmodule MalarkeyWeb.Credentials do
  alias Malarkey.Users.User
  alias Phoenix.LiveView.Socket
  alias Pow.Store.CredentialsCache

  def get_user(socket, session, config \\ [otp_app: :malarkey])

  def get_user(socket, %{"malarkey_auth" => signed_token}, config) do
    conn = struct!(Plug.Conn, secret_key_base: socket.endpoint.config(:secret_key_base))
    salt = Atom.to_string(Pow.Plug.Session)

    with {:ok, token} <- Pow.Plug.verify_token(conn, salt, signed_token, config),
         {user, _} <- CredentialsCache.get([backend: Pow.Store.Backend.EtsCache], token) do
      user
    else
      _ -> nil
    end
  end

  def get_user(_, _, _), do: nil
end
