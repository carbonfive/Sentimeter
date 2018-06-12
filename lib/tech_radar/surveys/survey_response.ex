defmodule TechRadar.Surveys.SurveyResponse do
  use Ecto.Schema
  import Ecto.Changeset
  alias TechRadar.Surveys.SurveyResponse

  schema "survey_responses" do
    field(:answers, {:map, :integer})
    field(:radar_guid, Ecto.UUID)

    timestamps()
  end

  @doc false
  def changeset(%SurveyResponse{} = survey_response, attrs) do
    survey_response
    |> cast(attrs, [:radar_guid, :answers])
    |> validate_required([:radar_guid, :answers])
  end
end
