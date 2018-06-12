defmodule TechRadar.Surveys.SurveyResponse do
  use Ecto.Schema
  import Ecto.Changeset
  alias TechRadar.Surveys.SurveyResponse

  schema "survey_responses" do
    field(:radar_guid, Ecto.UUID)

    timestamps()
  end

  @doc false
  def changeset(%SurveyResponse{} = survey_response, attrs) do
    survey_response
    |> cast(attrs, [:radar_guid])
    |> validate_required([:radar_guid])
  end
end
