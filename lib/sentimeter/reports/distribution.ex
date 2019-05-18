defmodule Sentimeter.Reports.Distribution do
  use Ecto.Schema
  import Ecto.Changeset

  @derive Jason.Encoder
  embedded_schema do
    field :lower_extreme, :float
    field :lower_quartile, :float
    field :median, :float
    field :upper_quartile, :float
    field :upper_extreme, :float
  end

  @doc false
  def changeset(distribution, attrs) do
    distribution
    |> cast(attrs, [:lower_extreme, :lower_quartile, :median, :upper_quartile, :upper_extreme])
    |> validate_required([
      :lower_extreme,
      :lower_quartile,
      :median,
      :upper_quartile,
      :upper_extreme
    ])
    |> validate_number(:lower_extreme, greater_than_or_equal_to: 1.0, less_than_or_equal_to: 5.0)
    |> validate_number(:lower_quartile, greater_than_or_equal_to: 1.0, less_than_or_equal_to: 5.0)
    |> validate_number(:median, greater_than_or_equal_to: 1.0, less_than_or_equal_to: 5.0)
    |> validate_number(:upper_quartile, greater_than_or_equal_to: 1.0, less_than_or_equal_to: 5.0)
    |> validate_number(:upper_extreme, greater_than_or_equal_to: 1.0, less_than_or_equal_to: 5.0)
  end
end
