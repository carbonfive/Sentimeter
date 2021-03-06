use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :sentimeter, SentimeterWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :sentimeter, Sentimeter.Repo,
  username: "postgres",
  password: "postgres",
  database: "sentimeter_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config(:sentimeter, :surveys, Sentimeter.SurveysMock)
config(:sentimeter, :responses, Sentimeter.ResponsesMock)
config(:sentimeter, :invitations, Sentimeter.InvitationsMock)
config(:sentimeter, :reports, Sentimeter.ReportsMock)

config :sentimeter, Sentimeter.Invitations.Mailer, adapter: Bamboo.TestAdapter
