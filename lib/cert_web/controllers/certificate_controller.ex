defmodule CertWeb.CertificateController do
  use CertWeb, :controller
  alias Cert.Accounts
  alias Cert.Courses

  def index(conn, _params) do
    user_type = get_session(conn, :user_type)
    user_id = get_session(conn, :user_id)
    user = Accounts.get_user_by_id(user_id)
    courses = Courses.get_all_courses()
    render(conn, "index.html", user: user,  user_type:  user_type, courses: courses)
  end

  def show(conn, %{"id" => id}) do
    course =
      id
      |> String.to_integer()
      |> Courses.get_course()


    id = get_session(conn, :user_id)
    user =
      id
      |> Accounts.get_user_by_id()

    render(conn, "show.html", user: user, course: course)
  end
end
