defmodule TechRadar.Surveys.Survey do
  use Ecto.Schema
  import Ecto.Changeset
  alias TechRadar.Surveys.Survey
  alias TechRadar.Surveys.SurveyQuestion

  embedded_schema do
    field(:radar_guid, Ecto.UUID)
    field(:category_1_name, :string)
    field(:category_2_name, :string)
    field(:category_3_name, :string)
    field(:category_4_name, :string)
    field(:innermost_level_name, :string)
    field(:intro, :string)
    field(:level_2_name, :string)
    field(:level_3_name, :string)
    field(:name, :string)
    field(:outermost_level_name, :string)
    embeds_many(:category_1_questions, SurveyQuestion)
    embeds_many(:category_2_questions, SurveyQuestion)
    embeds_many(:category_3_questions, SurveyQuestion)
    embeds_many(:category_4_questions, SurveyQuestion)
  end

  def changeset(%Survey{} = survey, attrs) do
    survey
    |> cast(attrs, [:radar_guid])
    |> validate_required([:radar_guid])
    |> cast_embed(:category_1_questions)
    |> cast_embed(:category_2_questions)
    |> cast_embed(:category_3_questions)
    |> cast_embed(:category_4_questions)
  end
end
