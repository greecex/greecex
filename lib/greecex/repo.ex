defmodule Greecex.Repo do
  use Ecto.Repo,
    otp_app: :greecex,
    adapter: Ecto.Adapters.Postgres
end
