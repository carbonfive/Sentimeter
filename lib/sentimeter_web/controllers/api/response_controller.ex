defmodule SentimeterWeb.Api.ResponseController do
  use SentimeterWeb, :controller

  alias Sentimeter.Responses
  alias Sentimeter.Surveys

  def index(conn, %{"survey_id" => survey_id}) do
    survey = Surveys.get_survey!(survey_id)
    responses = Responses.find_responses(survey_id: survey_id)
    render(conn, "index.json", responses: responses, survey: survey)
  end
end
