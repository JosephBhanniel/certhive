defmodule CertWeb.UserLive.Index do
  alias Cert.Accounts
  use CertWeb, :live_view
  @impl
  def mount(_params, session, socket) do
    user_id = Map.get(session, "user_id")
    user = Accounts.get_user_by_id(user_id)

    socket =
      socket
      |> assign(:user, user)

    {:ok, socket}
  end





end
