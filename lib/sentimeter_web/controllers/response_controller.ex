defmodule SentimeterWeb.ResponseController do
  use SentimeterWeb, :controller

  alias Sentimeter.Responses.Response

  @responses Application.get_env(:sentimeter, :responses)

  def index(conn, _params) do
    responses = @responses.list_responses()
    render(conn, "index.html", responses: responses)
  end

  def new(conn, _params) do
    changeset = @responses.change_response(%Response{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"response" => response_params}) do
    case @responses.create_response(response_params) do
      {:ok, response} ->
        conn
        |> put_flash(:info, "Response created successfully.")
        |> redirect(to: Routes.response_path(conn, :show, response))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    response = @responses.get_response!(id)
    render(conn, "show.html", response: response)
  end

  def edit(conn, %{"id" => id}) do
    response = @responses.get_response!(id)
    changeset = @responses.change_response(response)
    render(conn, "edit.html", response: response, changeset: changeset)
  end

  def update(conn, %{"id" => id, "response" => response_params}) do
    response = @responses.get_response!(id)

    case @responses.update_response(response, response_params) do
      {:ok, response} ->
        conn
        |> put_flash(:info, "Response updated successfully.")
        |> redirect(to: Routes.response_path(conn, :show, response))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", response: response, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    response = @responses.get_response!(id)
    {:ok, _response} = @responses.delete_response(response)

    conn
    |> put_flash(:info, "Response deleted successfully.")
    |> redirect(to: Routes.response_path(conn, :index))
  end
end
