defmodule CertWeb.AdminController do
  use CertWeb, :controller
  alias Cert.Accounts
  alias Cert.Repo
  alias Cert.Accounts.User

#function to display the dashboard
  def index(conn, _params) do
    user_id = get_session(conn, :user_id)
    user = Accounts.get_user_by_id(user_id )
    user_type = get_session(conn, :user_type)
    active_user_count = Accounts.count_active_users()
    inactive_user_count = Accounts.count_inactive_users()
    render(conn, "index.html", user: user, user_id: user_id, active_user_count: active_user_count, inactive_user_count: inactive_user_count, user_type: user_type)
  end


  #function to list all the users from the users table
  def users(conn, params) do
    # users = Accounts.get_all_users()
    page = User
    |> Repo.paginate(params)
    user_type = get_session(conn, :user_type)
    render(conn, "users.html", user_type: user_type, users: page.entries, page: page)
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


   #function to display the user details
  def view(conn, %{"id" => id}) do
    user_type = get_session(conn, :user_type)
    user = Accounts.get_user_by_id(id)
    changeset = Accounts.change_user(user)
    render(conn, "user_profile.html", user: user, changeset: changeset, user_type: user_type)
  end

  def edit_user(conn, %{"id" => id}) do
    user_type = get_session(conn, :user_type)
    user = Accounts.get_user_by_id(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit_user.html", user: user, changeset: changeset, user_type: user_type)
  end


  def update_user(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user_by_id(id)
    user_type = get_session(conn, :user_type)
    case Accounts.update_user_status(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.admin_path(conn, :view, user.id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit_user.html", user: user, changeset: changeset, user_type: user_type)
    end
  end

 #function to update admin details
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user_by_id(id)
    user_type = get_session(conn, :user_type)
    case Accounts.update_user(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.admin_path(conn, :user_profile, user_type: user_type))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset, user_type: user_type)
    end
  end


  def delete(conn, %{"id" => id}) do
    case Accounts.delete_user(id) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User deleted successfully.")
        |> redirect(to: Routes.admin_path(conn, :users))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Failed to delete User.")
        |> render("edit_user.html", changeset: changeset)
    end
  end

end
