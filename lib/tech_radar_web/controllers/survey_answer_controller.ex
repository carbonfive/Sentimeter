defmodule TechRadarWeb.SurveyAnswerController do
  use TechRadarWeb, :controller

  alias TechRadar.Surveys
  alias TechRadar.Surveys.SurveyAnswer

  def create(conn, %{"survey_answer" => survey_answer_params}) do
    case Surveys.create_survey_answer(survey_answer_params) do
      {:ok, survey_answer} ->
        conn
        |> put_flash(:info, "Survey answer created successfully.")
        |> redirect(to: survey_answer_path(conn, :show, survey_answer))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "form.html",
          changeset: changeset,
          action: survey_answer_path(conn, :create)
        )
    end
  end

  def show(conn, %{"id" => id}) do
    survey_answer = Surveys.get_survey_answer!(id)
    render(conn, "show.html", survey_answer: survey_answer)
  end

  def edit(conn, %{"id" => id}) do
    survey_answer = Surveys.get_survey_answer!(id)
    changeset = Surveys.change_survey_answer(survey_answer)
    render(conn, "edit.html", survey_answer: survey_answer, changeset: changeset)
  end

  def update(conn, %{"id" => id, "survey_answer" => survey_answer_params}) do
    survey_answer = Surveys.get_survey_answer!(id)

    case Surveys.update_survey_answer(survey_answer, survey_answer_params) do
      {:ok, survey_answer} ->
        conn
        |> put_flash(:info, "Survey answer updated successfully.")
        |> redirect(to: survey_answer_path(conn, :show, survey_answer))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", survey_answer: survey_answer, changeset: changeset)
    end
  end
end
