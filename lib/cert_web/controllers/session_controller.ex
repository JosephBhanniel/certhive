defmodule CertWeb.SessionController do
  use CertWeb, :controller
  import Ecto.Query, warn: false
  alias Cert.Repo
  alias Cert.Accounts.User

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def login(conn, %{"session" => %{"email" => email, "password" => password}}) do
    user = Repo.get_by(User, email: email)

    if user && user.status == "active" && Pbkdf2.verify_pass(password, user.password_hash) do
      conn =
        case user.user_type do
          "admin" ->
            conn
            |> put_session(:user_type, :Admin) # Set the user_type session for admin
            |> put_session(:user_id, user.id)
            |> redirect(to: "/admin/dashboard")
          "regular" ->
            conn
            |> put_session(:user_type, :Regular) # Set the user_type session for regular user
            |> put_session(:user_id, user.id)
            |> redirect(to: "/users/users")
          _ ->
            conn
        end

      if conn do
        conn
      else
        conn
        |> put_flash(:error, "Invalid username or password")
        |> redirect(to: "/login")
      end
    else
      conn
      |> put_flash(:error, "Invalid username or password")
      |> redirect(to: "/login")
    end
  end


  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> redirect(to: "/login")
  end
end
