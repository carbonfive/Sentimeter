defmodule TechRadar.AcceptanceCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL

      alias TechRadar.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import TechRadarWeb.Router.Helpers
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TechRadar.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(TechRadar.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(TechRadar.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    {:ok, session: session}
  end
end
