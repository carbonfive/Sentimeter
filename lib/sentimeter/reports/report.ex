defmodule Sentimeter.Reports.Report do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sentimeter.Reports.ReportTrend

  @derive Jason.Encoder
  embedded_schema do
    field(:name, :string)
    field(:x_max_label, :string)
    field(:x_min_label, :string)
    field(:y_max_label, :string)
    field(:y_min_label, :string)
    field(:response_count, :integer)
    embeds_many(:report_trends, ReportTrend, on_replace: :delete)
  end

  @doc false
  def changeset(report, attrs) do
    report
    |> cast(attrs, [
      :name,
      :x_max_label,
      :x_min_label,
      :y_max_label,
      :y_min_label,
      :response_count
    ])
    |> validate_required([
      :name,
      :x_max_label,
      :x_min_label,
      :y_max_label,
      :y_min_label,
      :response_count
    ])
    |> cast_embed(:report_trends)
  end
end
