defmodule Cert.Courses do
  @moduledoc """
  The Courses context.
  """

  import Ecto.Query, warn: false
  alias Cert.Repo

  alias Cert.Courses.Course


  def get_all_courses do
    Repo.all(Course)
  end

  def get_course(id) do
    Enum.find(get_all_courses(), &(&1.id == id))
  end



  def get_course!(id), do: Repo.get!(Course, id)

  def create_course(attrs \\ %{}) do
    %Course{}
    |> Course.changeset(attrs)
    |> Repo.insert()
  end


  def update_course(%Course{} = course, attrs) do
    course
    |> Course.changeset(attrs)
    |> Repo.update()
  end

  def delete_course(%Course{} = course) do
    Repo.delete(course)
  end


  def change_course(%Course{} = course, attrs \\ %{}) do
    Course.changeset(course, attrs)
  end
end
