defmodule Cert.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Cert.Repo

  alias Cert.Accounts.User





  def get_all_users do
    Repo.all(User)
  end





  def get_user_by_id(id), do: Repo.get!(User, id)

  def count_active_users do
    from(u in User, where: u.status == "active", select: count(u.id))
    |> Repo.one()
  end

  def count_inactive_users do
    from(u in User, where: u.status == "deleted", select: count(u.id))
    |> Repo.one()
  end



  def create_user(user_params) do
    case Ecto.Multi.new()
            |> Ecto.Multi.insert(:create_user, User.changeset(%User{}, user_params))
            |> Repo.transaction() do
      {:ok, %{create_user: user}} ->
        {:ok, user}
      {:error, _failed_operation, changeset, _multi} ->
        {:error, changeset}
    end
  end


  def update_user_status(%User{} = user, attrs) do
    user
    |> User.update_status(attrs)
    |> Repo.update()
  end



  def update_user(%User{} = user, attrs) do
    user
    |> User.update_profile(attrs)
    |> Repo.update()
  end


  # def delete_user(%User{} = user) do
  #   Repo.delete(user)
  # end


  def delete_user(id) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, fn _ ->
      user = Repo.get!(User, id)
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.put_change(:status, "deleted")
        |> Ecto.Changeset.validate_required([:status])

    end)
    |> Repo.transaction()
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
