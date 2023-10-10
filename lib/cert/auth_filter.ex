defmodule CertWeb.AuthFilter do

    import Plug.Conn
    import Phoenix.Controller

    def init(_opts), do: []

    def call(conn, _opts) do
      if authenticated?(conn) do
        conn
      else
        conn
        |> put_flash(:error, "Please log in to access this page")
        |> redirect(to: "/login")
        |> halt()
      end
    end

    defp authenticated?(conn) do
      user_id = get_session(conn, :user_id)
      !is_nil(user_id)
    end
  end
