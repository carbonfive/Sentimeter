defmodule Sentimeter.Surveys.SurveyTrend do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sentimeter.Surveys

  schema "survey_trends" do
    field(:delete, :boolean, virtual: true)
    field(:guid, Ecto.UUID, autogenerate: true)
    belongs_to(:survey, Surveys.Survey)
    belongs_to(:trend, Surveys.Trend)
    timestamps()
  end

  @doc false
  def changeset(survey_trend, attrs) do
    survey_trend
    |> cast(attrs, [:trend_id, :survey_id, :delete])
    |> validate_required([])
    |> mark_for_deletion()
  end

  defp mark_for_deletion(changeset) do
    # If delete was set and it is true, let's change the action
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
