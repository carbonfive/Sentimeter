defmodule TechRadarWeb.SurveyResponseController do
  use TechRadarWeb, :controller

  alias TechRadar.Surveys
  alias TechRadar.Surveys.SurveyResponse

  def create(conn, %{"survey_response" => survey_response_params}) do
    case Surveys.create_survey_response(survey_response_params) do
      {:ok, survey_response} ->
        conn
        |> put_flash(:info, "Survey response created successfully.")
        |> redirect(to: survey_response_path(conn, :show, survey_response))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "form.html",
          changeset: changeset,
          action: survey_response_path(conn, :create)
        )
    end
  end

  def show(conn, %{"id" => id}) do
    survey_response = Surveys.get_survey_response!(id)
    render(conn, "show.html", survey_response: survey_response)
  end

  def edit(conn, %{"id" => id}) do
    survey_response = Surveys.get_survey_response!(id)
    changeset = Surveys.change_survey_response(survey_response)
    render(conn, "edit.html", survey_response: survey_response, changeset: changeset)
  end

  def update(conn, %{"id" => id, "survey_response" => survey_response_params}) do
    survey_response = Surveys.get_survey_response!(id)

    case Surveys.update_survey_response(survey_response, survey_response_params) do
      {:ok, survey_response} ->
        conn
        |> put_flash(:info, "Survey response updated successfully.")
        |> redirect(to: survey_response_path(conn, :show, survey_response))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", survey_response: survey_response, changeset: changeset)
    end
  end
end
