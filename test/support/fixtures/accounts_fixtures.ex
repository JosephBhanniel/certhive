defmodule Cert.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cert.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        firstname: "some firstname",
        lastname: "some lastname",
        password_hash: "some password_hash",
        status: "some status",
        user_type: "some user_type",
        username: "some username"
      })
      |> Cert.Accounts.create_user()

    user
  end
end
