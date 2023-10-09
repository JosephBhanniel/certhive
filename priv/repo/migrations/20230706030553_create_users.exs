defmodule Cert.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :firstname, :string
      add :lastname, :string
      add :email, :string
      add :username, :string
      add :user_type, :string
      add :status, :string
      add :password_hash, :string

      timestamps()
    end
  end
end
