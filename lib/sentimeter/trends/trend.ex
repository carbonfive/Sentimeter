defmodule Sentimeter.Trends.Trend do
  use Ecto.Schema
  import Ecto.Changeset


  schema "trends" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(trend, attrs) do
    trend
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
