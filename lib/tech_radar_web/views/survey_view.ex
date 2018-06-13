defmodule TechRadarWeb.SurveyView do
  use TechRadarWeb, :view

  alias TechRadar.Surveys.Survey

  @spec level_options(%Ecto.Changeset{data: %Survey{}}) :: [{String.t(), integer()}]
  def level_options(%Ecto.Changeset{data: survey}) do
    [
      {survey.innermost_level_name, 1},
      {survey.level_2_name, 2},
      {survey.level_3_name, 3},
      {survey.outermost_level_name, 4}
    ]
  end
end
