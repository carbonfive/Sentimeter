defmodule TechRadarWeb.SurveyResponseView do
  use TechRadarWeb, :view
  alias TechRadar.Surveys.Survey

  @spec answer_name(answer :: number, survey :: %Survey{}) :: String.t()
  def answer_name(answer, %Survey{} = survey) do
    case answer do
      1 -> survey.innermost_level_name
      2 -> survey.level_2_name
      3 -> survey.level_3_name
      4 -> survey.outermost_level_name
    end
  end
end
