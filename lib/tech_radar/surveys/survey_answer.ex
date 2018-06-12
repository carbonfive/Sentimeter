defmodule TechRadar.Surveys.SurveyAnswer do
  use Ecto.Schema
  import Ecto.Changeset
  alias TechRadar.Surveys.SurveyAnswer
  alias TechRadar.Surveys.SurveyResponse

  schema "survey_answers" do
    field(:answer, :integer)
    field(:radar_trend_guid, Ecto.UUID)
    belongs_to(:survey_response, SurveyResponse)

    timestamps()
  end

  @doc false
  def changeset(%SurveyAnswer{} = survey_answer, attrs) do
    survey_answer
    |> cast(attrs, [:radar_trend_guid, :answer])
    |> validate_number(:answer, greater_than: 0, less_than_or_equal_to: 4)
    |> validate_required([:radar_trend_guid, :answer])
  end
end
