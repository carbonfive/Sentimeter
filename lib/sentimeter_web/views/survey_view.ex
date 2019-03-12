defmodule SentimeterWeb.SurveyView do
  use SentimeterWeb, :view
    def link_to_survey_trend_fields(trends) do
    changeset = Sentimeter.Surveys.change_survey(%Sentimeter.Surveys.Survey{survey_trends: [%Sentimeter.Surveys.SurveyTrend{}]})
    form = Phoenix.HTML.FormData.to_form(changeset, [])
    fields = render_to_string(__MODULE__, "survey_trend_fields.html", f: form, trends: trends)
    link("Add Survey Trend", to: "#", "data-template": fields, id: "add-survey-trend", class: "button button-outline")
  end
end
