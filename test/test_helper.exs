ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(TechRadar.Repo, :manual)

# Auto-skip tests with @tag :skip
ExUnit.configure(exclude: [skip: true])

# Wallaby
{:ok, _} = Application.ensure_all_started(:wallaby)
Application.put_env(:wallaby, :base_url, TechRadarWeb.Endpoint.url())

# ExMachina
{:ok, _} = Application.ensure_all_started(:ex_machina)

# Mox
{:ok, _} = Application.ensure_all_started(:mox)
