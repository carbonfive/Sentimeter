defmodule SentimeterWeb.Api.ResponseView do
  use SentimeterWeb, :view
  alias SentimeterWeb.Api.ResponseView

  def render("index.json", %{responses: responses, survey: survey}) do
    %{
      survey: render_survey(survey),
      responses: render_many(responses, ResponseView, "response.json")
    }
  end

  def render("response.json", %{response: response}) do
    %{x: response.x, y: response.y, trend: response.trend.name}
  end

  defp render_survey(survey) do
    %{
      name: survey.name,
      x_axis_labels: [survey.x_min_label, survey.x_max_label],
      y_axis_labels: [survey.y_min_label, survey.y_max_label]
    }
  end
end
