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
    conn = assign(conn, :dark, true)

    live_render(conn, SentimeterWeb.ResponseLive.Edit,
      session: %{guid: guid, session_guid: Ecto.UUID.generate()}
    )
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
