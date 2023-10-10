defmodule Cert.CoursesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cert.Courses` context.
  """

  @doc """
  Generate a course.
  """
  def course_fixture(attrs \\ %{}) do
    {:ok, course} =
      attrs
      |> Enum.into(%{
        description: "some description",
        duration: 42,
        name: "some name"
      })
      |> Cert.Courses.create_course()

    course
  end
end
