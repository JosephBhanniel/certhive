defmodule Cert.Repo do
  use Ecto.Repo,
    otp_app: :cert,
    adapter: Ecto.Adapters.Postgres
    use Scrivener, page_size: 4
end
