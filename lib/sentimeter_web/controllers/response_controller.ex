defmodule SentimeterWeb.ResponseController do
  use SentimeterWeb, :controller

  alias Sentimeter.Responses
  alias Sentimeter.Responses.Response
  alias Sentimeter.Trends

  def index(conn, %{"survey_id" => survey_id}) do
    responses = Responses.find_responses(survey_id: survey_id)
    render(conn, "index.html", responses: responses, survey_id: survey_id)
  end

  def new(conn, %{"survey_id" => survey_id}) do
    changeset = Responses.change_response(%Response{})

    render(conn, "new.html",
      changeset: changeset,
      survey_id: survey_id,
      trends: Trends.list_trends()
    )
  end

  def create(conn, %{"response" => response_params, "survey_id" => survey_id}) do
    case Responses.create_response(response_params |> Map.put("survey_id", survey_id)) do
      {:ok, response} ->
        conn
        |> put_flash(:info, "Response created successfully.")
        |> redirect(to: Routes.survey_response_path(conn, :show, survey_id, response))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html",
          changeset: changeset,
          survey_id: survey_id,
          trends: Trends.list_trends()
        )
    end
  end

  def show(conn, %{"id" => id, "survey_id" => survey_id}) do
    response = Responses.get_response!(id)
    render(conn, "show.html", response: response, survey_id: survey_id)
  end

  def edit(conn, %{"id" => id, "survey_id" => survey_id}) do
    response = Responses.get_response!(id)
    changeset = Responses.change_response(response)

    render(conn, "edit.html",
      response: response,
      changeset: changeset,
      survey_id: survey_id,
      trends: Trends.list_trends()
    )
  end

  def update(conn, %{"id" => id, "response" => response_params, "survey_id" => survey_id}) do
    response = Responses.get_response!(id)

    case Responses.update_response(response, response_params) do
      {:ok, response} ->
        conn
        |> put_flash(:info, "Response updated successfully.")
        |> redirect(to: Routes.survey_response_path(conn, :show, survey_id, response))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          response: response,
          changeset: changeset,
          survey_id: survey_id,
          trends: Trends.list_trends()
        )
    end
  end

  def delete(conn, %{"id" => id, "survey_id" => survey_id}) do
    response = Responses.get_response!(id)
    {:ok, _response} = Responses.delete_response(response)

    conn
    |> put_flash(:info, "Response deleted successfully.")
    |> redirect(to: Routes.survey_response_path(conn, :index, survey_id))
  end
end
