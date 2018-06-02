defmodule TechRadarWeb.RadarController do
  use TechRadarWeb, :controller

  alias TechRadar.Radars
  alias TechRadar.Radars.Radar

  def index(conn, _params) do
    radars = Radars.list_radars()
    render(conn, "index.html", radars: radars)
  end

  def new(conn, _params) do
    changeset = Radars.change_radar(%Radar{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"radar" => radar_params}) do
    case Radars.create_radar(radar_params) do
      {:ok, radar} ->
        conn
        |> put_flash(:info, "Radar created successfully.")
        |> redirect(to: radar_path(conn, :show, radar))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    radar = Radars.get_radar!(id)
    render(conn, "show.html", radar: radar)
  end

  def edit(conn, %{"id" => id}) do
    radar = Radars.get_radar!(id)
    changeset = Radars.change_radar(radar)
    render(conn, "edit.html", radar: radar, changeset: changeset)
  end

  def update(conn, %{"id" => id, "radar" => radar_params}) do
    radar = Radars.get_radar!(id)

    case Radars.update_radar(radar, radar_params) do
      {:ok, radar} ->
        conn
        |> put_flash(:info, "Radar updated successfully.")
        |> redirect(to: radar_path(conn, :show, radar))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", radar: radar, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    radar = Radars.get_radar!(id)
    {:ok, _radar} = Radars.delete_radar(radar)

    conn
    |> put_flash(:info, "Radar deleted successfully.")
    |> redirect(to: radar_path(conn, :index))
  end
end
