defmodule TechRadar.Surveys.SurveyQuestion do
  use Ecto.Schema
  import Ecto.Changeset
  alias TechRadar.Surveys.SurveyQuestion

  @primary_key {:id, :id, autogenerate: false}
  embedded_schema do
    field(:answer, :integer)
    field(:radar_trend_guid, Ecto.UUID)

    embeds_one :trend, Trend do
      field(:description, :string)
      field(:name, :string)
    end
  end

  def changeset(%SurveyQuestion{} = survey_question, attrs) do
    survey_question
    |> cast(attrs, [:radar_trend_guid, :answer, :id])
    |> validate_number(:answer, greater_than: 0, less_than_or_equal_to: 4)
    |> validate_required([:radar_trend_guid, :answer])
  end
end
