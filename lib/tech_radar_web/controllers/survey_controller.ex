defmodule TechRadarWeb.SurveyController do
  use TechRadarWeb, :controller

  @surveys Application.get_env(:tech_radar, :surveys)

  def show(conn, %{"guid" => guid}) do
    survey = @surveys.survey_from_radar_guid!(guid)
    changeset = @surveys.change_survey(survey)
    render(conn, "show.html", changeset: changeset)
  end

  def create(conn, %{"survey" => survey_params}) do
    case @surveys.create_survey_response_from_survey(survey_params) do
      {:ok, survey_response} ->
        conn
        |> put_flash(:info, "Survey response created successfully.")
        |> redirect(to: survey_response_path(conn, :show, survey_response))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "form.html",
          changeset: changeset,
          action: survey_response_path(conn, :create),
          method: 'POST'
        )
    end
  end
end
