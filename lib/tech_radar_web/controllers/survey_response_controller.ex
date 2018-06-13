defmodule TechRadarWeb.SurveyResponseController do
  use TechRadarWeb, :controller

  alias TechRadar.Surveys

  def show(conn, %{"id" => id}) do
    survey_response = Surveys.get_survey_response!(id)
    survey = Surveys.survey_from_survey_response!(survey_response)
    render(conn, "show.html", survey_response: survey_response, survey: survey)
  end

  def edit(conn, %{"id" => id}) do
    survey_response = Surveys.get_survey_response!(id)
    survey = Surveys.survey_from_survey_response!(survey_response)
    changeset = Surveys.change_survey(survey)
    render(conn, "edit.html", survey_response: survey_response, changeset: changeset)
  end

  def update(conn, %{"id" => id, "survey" => survey_params}) do
    survey_response = Surveys.get_survey_response!(id)

    case Surveys.update_survey_response_from_survey(survey_response, survey_params) do
      {:ok, survey_response} ->
        conn
        |> put_flash(:info, "Survey response updated successfully.")
        |> redirect(to: survey_response_path(conn, :show, survey_response))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", survey_response: survey_response, changeset: changeset)
    end
  end
end
