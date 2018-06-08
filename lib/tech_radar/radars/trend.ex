defmodule TechRadar.Radars.Trend do
  use Ecto.Schema
  import Ecto.Changeset
  alias TechRadar.Radars.Trend
  alias TechRadar.Radars.RadarTrend

  schema "trends" do
    field(:description, :string)
    field(:name, :string)
    has_many(:radar_trends, RadarTrend)
    timestamps()
  end

  @doc false
  def changeset(%Trend{} = trend, attrs) do
    trend
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
