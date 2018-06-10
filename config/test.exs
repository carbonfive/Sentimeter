use Mix.Config

# We run a server during test for Wallaby integration testing.
config :tech_radar, TechRadarWeb.Endpoint,
  http: [port: 4001],
  server: true,
  secret_key_base: "0123456789012345678901234567890123456789012345678901234567890123456789"

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :tech_radar, TechRadar.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "tech_radar_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :tech_radar, :sql_sandbox, true

config(:tech_radar, :radars, TechRadar.Radars.RadarsImpl)
