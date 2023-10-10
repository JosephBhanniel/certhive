defmodule CertWeb.PageController do
  use CertWeb, :controller
  alias Cert.Accounts
  alias Cert.Accounts.User

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end


  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "successfully registered.")
        |> redirect(to: Routes.session_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

end
