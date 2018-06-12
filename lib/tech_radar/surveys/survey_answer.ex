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

  defp validate_answers_complete(changeset) do
    case changeset.valid? do
      true ->
        radar_guid = get_field(changeset, :radar_guid)
        answer_guids = Map.keys(get_field(changeset, :answers))

      _ -> changeset
    end
  end
end
