defmodule CertWeb.UserLive.Profile do
  alias Cert.Accounts

  use CertWeb, :live_view

  def mount(_params, session, socket) do
    user_id = Map.get(session, "user_id")
    user = Accounts.get_user_by_id(user_id)

    socket =
      socket
      |> assign(:user, user)

    {:ok, socket}
  end



end
