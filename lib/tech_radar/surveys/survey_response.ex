defmodule TechRadar.Surveys.SurveyResponse do
  use Ecto.Schema
  import Ecto.Changeset
  alias TechRadar.Surveys.SurveyResponse
  alias TechRadar.Surveys.SurveyAnswer

  schema "survey_responses" do
    field(:radar_guid, Ecto.UUID)
    has_many(:survey_answers, SurveyAnswer, on_delete: :delete_all, on_replace: :delete)
    timestamps()
  end

  @doc false
  def changeset(%SurveyResponse{} = survey_response, attrs) do
    survey_response
    |> cast(attrs, [:radar_guid])
    |> validate_required([:radar_guid])
    |> cast_assoc(:survey_answers)
  end
end
