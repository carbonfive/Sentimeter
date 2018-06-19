defmodule TechRadarWeb.SurveyResponseController do
  use TechRadarWeb, :controller

  @surveys Application.get_env(:tech_radar, :surveys)

  def show(conn, %{"id" => id}) do
    survey_response = @surveys.get_survey_response!(id)
    survey = @surveys.survey_from_survey_response!(survey_response)
    render(conn, "show.html", survey_response: survey_response, survey: survey)
  end

  def edit(conn, %{"id" => id}) do
    survey_response = @surveys.get_survey_response!(id)
    survey = @surveys.survey_from_survey_response!(survey_response)
    changeset = @surveys.change_survey(survey)
    render(conn, "edit.html", survey_response: survey_response, changeset: changeset)
  end

  def update(conn, %{"id" => id, "survey" => survey_params}) do
    survey_response = @surveys.get_survey_response!(id)

    case @surveys.update_survey_response_from_survey(survey_response, survey_params) do
      {:ok, survey_response} ->
        conn
        |> put_flash(:info, "Survey response updated successfully.")
        |> redirect(to: survey_response_path(conn, :show, survey_response))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", survey_response: survey_response, changeset: changeset)
    end
  end
end
