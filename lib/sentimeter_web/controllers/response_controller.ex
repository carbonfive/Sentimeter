defmodule SentimeterWeb.ResponseController do
  use SentimeterWeb, :controller

  @responses Application.get_env(:sentimeter, :responses)
  @surveys Application.get_env(:sentimeter, :surveys)
  def index(conn, %{"survey_id" => survey_id}) do
    survey = @surveys.get_survey!(survey_id)
    responses = @responses.responses_for_survey_guid(survey.guid)
    render(conn, "index.html", survey: survey, responses: responses)
  end

  def create(conn, %{"survey_id" => survey_id, "response" => response_params}) do
    survey = @surveys.get_survey!(survey_id)

    emails =
      String.split(response_params["emails"] || "", "\n")
      |> Enum.map(fn email -> String.trim(email) end)

    case @responses.create_responses(emails, survey.guid) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Responses created successfully.")
        |> redirect(to: Routes.survey_response_path(conn, :index, survey))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "index.html",
          survey: survey,
          responses: @responses.responses_for_survey_guid(survey.guid),
          errors: [emails: Keyword.get_values(changeset.errors, :email)]
        )
    end
  end

  def show(conn, %{"guid" => guid}) do
    response = @responses.get_response_by_guid!(guid)
    survey = @surveys.get_survey_by_guid!(response.survey_guid)
    render(conn, "show.html", response: response, survey: survey)
  end

  def edit(conn, %{"guid" => guid}) do
    response = @responses.get_response_by_guid!(guid)
    survey = @surveys.get_survey_by_guid!(response.survey_guid)
    changeset = @responses.change_response(response)
    render(conn, "edit.html", response: response, changeset: changeset, survey: survey)
  end

  def update(conn, %{"guid" => guid, "response" => response_params}) do
    response = @responses.get_response_by_guid!(guid)
    survey = @surveys.get_survey_by_guid!(response.survey_guid)

    case @responses.update_response(response, response_params) do
      {:ok, response} ->
        conn
        |> put_flash(:info, "Response updated successfully.")
        |> redirect(to: Routes.response_path(conn, :show, response.guid))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", response: response, changeset: changeset, survey: survey)
    end
  end

  def delete(conn, %{"guid" => guid}) do
    response = @responses.get_response_by_guid!(guid)
    survey = @surveys.get_survey_by_guid!(response.survey_guid)
    {:ok, _response} = @responses.delete_response(response)

    conn
    |> put_flash(:info, "Response deleted successfully.")
    |> redirect(to: Routes.survey_response_path(conn, :index, survey))
  end
end
