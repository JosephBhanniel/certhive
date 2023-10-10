defmodule CertWeb.UserController do
  use CertWeb, :controller
  alias Cert.Accounts

  def index(conn, _params) do
    user_id = get_session(conn, :user_id)
    user = Accounts.get_user_by_id(user_id )
    user_type = get_session(conn, :user_type)
    render(conn, "index.html", user: user, user_id: user_id, user_type: user_type)
  end

  #function to view user's rofile
  def user_profile(conn, _params) do
    user_id = get_session(conn, :user_id)
    user = Accounts.get_user_by_id(user_id)
    user_type = get_session(conn, :user_type)
    render(conn, "profile.html", user: user, user_type: user_type)
  end


  #function to display the admin details to edit
  def edit(conn, _) do
    user_id = get_session(conn, :user_id)
    user_type = get_session(conn, :user_type)
    user = Accounts.get_user_by_id(user_id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset, user_type: user_type)
  end

   #function to update admin details
   def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user_by_id(id)
    user_type = get_session(conn, :user_type)
    case Accounts.update_user(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :user_profile, user_type: user_type))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset, user_type: user_type)
    end
  end


end
