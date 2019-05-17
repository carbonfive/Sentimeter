defmodule Sentimeter.Reports.ReportTrend do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sentimeter.Reports.Distribution
  alias Sentimeter.Reports.ReportResponse

  embedded_schema do
    field :name, :string
    field :description, :string
    field :influential, :integer
    field :would_recommend, :integer
    field :x_plot, :float
    field :y_plot, :float
    embeds_one(:x_axis_distribution, Distribution)
    embeds_one(:y_axis_distribution, Distribution)
    embeds_many(:responses, ReportResponse, on_replace: :delete)
  end

  @doc false
  def changeset(report_trend, attrs) do
    report_trend
    |> cast(attrs, [:name, :description, :influential, :would_recommend, :x_plot, :y_plot])
    |> validate_required([:name, :description, :influential, :would_recommend, :x_plot, :y_plot])
    |> validate_number(:x_plot, greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0)
    |> validate_number(:y_plot, greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0)
    |> cast_embed(:x_axis_distribution)
    |> cast_embed(:y_axis_distribution)
    |> cast_embed(:responses)
  end
end
