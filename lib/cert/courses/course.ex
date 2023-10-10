defmodule Cert.Courses.Course do
  use Ecto.Schema
  import Ecto.Changeset

  schema "courses" do
    field :description, :string
    field :duration, :integer
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(course, attrs) do
    course
    |> cast(attrs, [:name, :description, :duration])
    |> validate_required([:name, :description, :duration])
  end
end
