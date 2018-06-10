defmodule TechRadar.Surveys.SurveyAnswer do
  use Ecto.Schema
  import Ecto.Changeset
  alias TechRadar.Surveys.SurveyAnswer


  schema "survey_answers" do
    field :answers, {:map, :integer}
    field :radar_guid, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(%SurveyAnswer{} = survey_answer, attrs) do
    survey_answer
    |> cast(attrs, [:radar_guid, :answers])
    |> validate_required([:radar_guid, :answers])
  end
end
