defmodule Malarkey.Users do
  alias Malarkey.Repo

  def find_user(id) do
    Repo.get(User, id)
  end
end
