defmodule Sentimeter.Surveys.Trend do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sentimeter.Surveys.Trend
  alias Sentimeter.Surveys.SurveyTrend

  schema "trends" do
    field(:name, :string)
    field(:description, :string)
    has_many(:survey_trends, SurveyTrend)

    timestamps()
  end

  @doc false
  def changeset(%Trend{} = trend, attrs) do
    trend
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
