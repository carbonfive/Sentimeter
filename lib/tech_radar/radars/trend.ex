defmodule TechRadar.Radars.Trend do
  use Ecto.Schema
  import Ecto.Changeset
  alias TechRadar.Radars.Trend


  schema "trends" do
    field :description, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Trend{} = trend, attrs) do
    trend
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
