defmodule Sentimeter.Surveys.Survey do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sentimeter.Surveys.SurveyTrend
  alias Sentimeter.Trends.Trend

  schema "surveys" do
    field :closing, :string
    field :intro, :string
    field :name, :string
    field :section_1_desc, :string
    field :section_2_desc, :string
    field :x_max_label, :string
    field :x_min_label, :string
    field :y_max_label, :string
    field :y_min_label, :string
    has_many(:survey_trends, SurveyTrend, on_delete: :delete_all)
    has_many(:trends, through: [:survey_trends, :trend])
    timestamps()
  end

  @doc false
  def changeset(survey, attrs) do
    survey
    |> cast(attrs, [
      :name,
      :x_min_label,
      :x_max_label,
      :y_min_label,
      :y_max_label,
      :intro,
      :section_1_desc,
      :section_2_desc,
      :closing
    ])
    |> validate_required([
      :name,
      :x_min_label,
      :x_max_label,
      :y_min_label,
      :y_max_label,
      :intro,
      :section_1_desc,
      :section_2_desc,
      :closing
    ])
    |> cast_assoc(:survey_trends)
  end
end
