defmodule Feelgood.Repo do
  use Ecto.Repo,
    otp_app: :feelgood,
    adapter: Ecto.Adapters.Postgres
end
