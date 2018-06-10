defmodule TechRadarWeb.RadarController do
  use TechRadarWeb, :controller

  alias TechRadar.Radars.Radar

  @default_innermost_level_name "Adopt"
  @default_level_2_name "Trial"
  @default_level_3_name "Assess"
  @default_outermost_level_name "Hold"
  @default_category_1_name "Techniques"
  @default_category_2_name "Tools"
  @default_category_3_name "Languages & Frameworks"
  @default_category_4_name "Platforms"

  @radars Application.get_env(:tech_radar, :radars)

  def index(conn, _params) do
    radars = @radars.list_radars()
    render(conn, "index.html", radars: radars)
  end

  def new(conn, _params) do
    changeset =
      @radars.change_radar(%Radar{
        innermost_level_name: @default_innermost_level_name,
        level_2_name: @default_level_2_name,
        level_3_name: @default_level_3_name,
        outermost_level_name: @default_outermost_level_name,
        category_1_name: @default_category_1_name,
        category_2_name: @default_category_2_name,
        category_3_name: @default_category_3_name,
        category_4_name: @default_category_4_name
      })

    render(conn, "new.html", changeset: changeset, trends: @radars.list_trends())
  end

  def create(conn, %{"radar" => radar_params}) do
    case @radars.create_radar(radar_params) do
      {:ok, radar} ->
        conn
        |> put_flash(:info, "Radar created successfully.")
        |> redirect(to: radar_path(conn, :show, radar))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, trends: @radars.list_trends())
    end
  end

  def show(conn, %{"id" => id}) do
    radar = @radars.get_radar!(id)
    render(conn, "show.html", radar: radar)
  end

  def edit(conn, %{"id" => id}) do
    radar = @radars.get_radar!(id)
    changeset = @radars.change_radar(radar)
    render(conn, "edit.html", radar: radar, changeset: changeset, trends: @radars.list_trends())
  end

  def update(conn, %{"id" => id, "radar" => radar_params}) do
    radar = @radars.get_radar!(id)

    case @radars.update_radar(radar, radar_params) do
      {:ok, radar} ->
        conn
        |> put_flash(:info, "Radar updated successfully.")
        |> redirect(to: radar_path(conn, :show, radar))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "edit.html",
          radar: radar,
          changeset: changeset,
          trends: @radars.list_trends()
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    radar = @radars.get_radar!(id)
    {:ok, _radar} = @radars.delete_radar(radar)

    conn
    |> put_flash(:info, "Radar deleted successfully.")
    |> redirect(to: radar_path(conn, :index))
  end
end
