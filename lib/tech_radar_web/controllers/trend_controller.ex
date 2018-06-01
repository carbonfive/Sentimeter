defmodule TechRadarWeb.TrendController do
  use TechRadarWeb, :controller

  alias TechRadar.Radars
  alias TechRadar.Radars.Trend

  def index(conn, _params) do
    trends = Radars.list_trends()
    render(conn, "index.html", trends: trends)
  end

  def new(conn, _params) do
    changeset = Radars.change_trend(%Trend{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"trend" => trend_params}) do
    case Radars.create_trend(trend_params) do
      {:ok, trend} ->
        conn
        |> put_flash(:info, "Trend created successfully.")
        |> redirect(to: trend_path(conn, :show, trend))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    trend = Radars.get_trend!(id)
    render(conn, "show.html", trend: trend)
  end

  def edit(conn, %{"id" => id}) do
    trend = Radars.get_trend!(id)
    changeset = Radars.change_trend(trend)
    render(conn, "edit.html", trend: trend, changeset: changeset)
  end

  def update(conn, %{"id" => id, "trend" => trend_params}) do
    trend = Radars.get_trend!(id)

    case Radars.update_trend(trend, trend_params) do
      {:ok, trend} ->
        conn
        |> put_flash(:info, "Trend updated successfully.")
        |> redirect(to: trend_path(conn, :show, trend))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", trend: trend, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    trend = Radars.get_trend!(id)
    {:ok, _trend} = Radars.delete_trend(trend)

    conn
    |> put_flash(:info, "Trend deleted successfully.")
    |> redirect(to: trend_path(conn, :index))
  end
end
