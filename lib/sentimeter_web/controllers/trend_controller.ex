defmodule SentimeterWeb.TrendController do
  use SentimeterWeb, :controller

  alias Sentimeter.Surveys.Trend

  @surveys Application.get_env(:sentimeter, :surveys)

  def index(conn, _params) do
    trends = @surveys.list_trends()
    render(conn, "index.html", trends: trends)
  end

  def new(conn, _params) do
    changeset = @surveys.change_trend(%Trend{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"trend" => trend_params}) do
    case @surveys.create_trend(trend_params) do
      {:ok, trend} ->
        conn
        |> put_flash(:info, "Trend created successfully.")
        |> redirect(to: Routes.trend_path(conn, :show, trend))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    trend = @surveys.get_trend!(id)
    render(conn, "show.html", trend: trend)
  end

  def edit(conn, %{"id" => id}) do
    trend = @surveys.get_trend!(id)
    changeset = @surveys.change_trend(trend)
    render(conn, "edit.html", trend: trend, changeset: changeset)
  end

  def update(conn, %{"id" => id, "trend" => trend_params}) do
    trend = @surveys.get_trend!(id)

    case @surveys.update_trend(trend, trend_params) do
      {:ok, trend} ->
        conn
        |> put_flash(:info, "Trend updated successfully.")
        |> redirect(to: Routes.trend_path(conn, :show, trend))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", trend: trend, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    trend = @surveys.get_trend!(id)
    {:ok, _trend} = @surveys.delete_trend(trend)

    conn
    |> put_flash(:info, "Trend deleted successfully.")
    |> redirect(to: Routes.trend_path(conn, :index))
  end
end
