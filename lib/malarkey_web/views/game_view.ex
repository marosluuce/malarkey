defmodule MalarkeyWeb.GameView do
  use MalarkeyWeb, :view

  def has_not_voted(user, votes) do
    voters = Enum.map(votes, & &1.user_id)

    not (user.id in voters)
  end
end
