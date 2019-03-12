defmodule SentimeterWeb.SurveyController do
  use SentimeterWeb, :controller

  alias Sentimeter.Surveys
  alias Sentimeter.Trends
  alias Sentimeter.Surveys.Survey

  def index(conn, _params) do
    surveys = Surveys.list_surveys()
    render(conn, "index.html", surveys: surveys)
  end

  def new(conn, _params) do
    changeset = Surveys.change_survey(%Survey{})
    render(conn, "new.html", changeset: changeset, trends: Trends.list_trends())
  end

  def create(conn, %{"survey" => survey_params}) do
    case Surveys.create_survey(survey_params) do
      {:ok, survey} ->
        conn
        |> put_flash(:info, "Survey created successfully.")
        |> redirect(to: Routes.survey_path(conn, :show, survey))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, trends: Trends.list_trends())
    end
  end

  def show(conn, %{"id" => id}) do
    survey = Surveys.get_survey!(id)
    render(conn, "show.html", survey: survey, trends: Trends.list_trends())
  end

  def edit(conn, %{"id" => id}) do
    survey = Surveys.get_survey!(id)
    changeset = Surveys.change_survey(survey)
    render(conn, "edit.html", survey: survey, changeset: changeset, trends: Trends.list_trends())
  end

  def update(conn, %{"id" => id, "survey" => survey_params}) do
    survey = Surveys.get_survey!(id)

    case Surveys.update_survey(survey, survey_params) do
      {:ok, survey} ->
        conn
        |> put_flash(:info, "Survey updated successfully.")
        |> redirect(to: Routes.survey_path(conn, :show, survey))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", survey: survey, changeset: changeset, trends: Trends.list_trends())
    end
  end

  def delete(conn, %{"id" => id}) do
    survey = Surveys.get_survey!(id)
    {:ok, _survey} = Surveys.delete_survey(survey)

    conn
    |> put_flash(:info, "Survey deleted successfully.")
    |> redirect(to: Routes.survey_path(conn, :index))
  end
end
