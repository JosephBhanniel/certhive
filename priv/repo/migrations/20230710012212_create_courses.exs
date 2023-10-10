defmodule Cert.Repo.Migrations.CreateCourses do
  use Ecto.Migration

  def change do
    create table(:courses) do
      add :name, :string
      add :description, :text
      add :duration, :integer

      timestamps()
    end
  end
end
