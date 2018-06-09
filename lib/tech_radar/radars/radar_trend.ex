defmodule TechRadar.Radars.RadarTrend do
  use Ecto.Schema
  import Ecto.Changeset
  alias TechRadar.Radars.RadarTrend
  alias TechRadar.Radars.Radar
  alias TechRadar.Radars.Trend

  schema "radar_trends" do
    field(:category, :integer)
    field(:delete, :boolean, virtual: true)
    field(:guid, Ecto.UUID, autogenerate: true)
    belongs_to(:trend, Trend)
    belongs_to(:radar, Radar)
    timestamps()
  end

  @doc false
  def changeset(%RadarTrend{} = radar_trend, attrs) do
    radar_trend
    |> cast(attrs, [:category, :trend_id, :delete])
    |> validate_required([:category])
    |> mark_for_deletion()
  end

  defp mark_for_deletion(changeset) do
    # If delete was set and it is true, let's change the action
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
