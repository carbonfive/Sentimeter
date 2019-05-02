defmodule Sentimeter.Repo do
  use Ecto.Repo,
    otp_app: :sentimeter,
    adapter: Ecto.Adapters.Postgres
end
