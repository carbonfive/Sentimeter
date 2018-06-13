defmodule TechRadarWeb.SurveyController do
  use TechRadarWeb, :controller

  alias TechRadar.Surveys

  def show(conn, %{"guid" => guid}) do
    survey = Surveys.survey_from_radar_guid!(guid)
    changeset = Surveys.change_survey(survey)
    render(conn, "show.html", survey: survey, changeset: changeset)
  end

  def create(_conn, %{"survey" => _survey_params}) do
  end
end
