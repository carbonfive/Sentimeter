defmodule TechRadarWeb.RadarControllerTest do
  use TechRadarWeb.ConnCase
  import Mox
  alias TechRadar.RadarsMock
  alias TechRadar.Radars.Radar

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def changeset(%Radar{} = radar, attrs \\ %{}) do
    Ecto.Changeset.change(radar, attrs)
  end

  setup do
    RadarsMock |> stub(:change_radar, fn radar -> changeset(radar) end)
    RadarsMock |> stub(:list_trends, fn -> [] end)
    :ok
  end

  setup :verify_on_exit!

  describe "index" do
    test "lists all radars", %{conn: conn} do
      RadarsMock |> expect(:list_radars, fn -> [] end)
      conn = get(conn, radar_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Radars"
    end
  end

  describe "new radar" do
    test "renders form", %{conn: conn} do
      RadarsMock |> expect(:change_radar, 1, fn radar -> changeset(radar) end)
      conn = get(conn, radar_path(conn, :new))
      assert html_response(conn, 200) =~ "New Radar"
    end
  end

  describe "create radar" do
    test "redirects to show when data is valid", %{conn: conn} do
      RadarsMock |> expect(:create_radar, fn _ -> {:ok, %Radar{id: 1}} end)
      conn = post(conn, radar_path(conn, :create), radar: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == radar_path(conn, :show, id)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      RadarsMock
      |> expect(:create_radar, fn _ ->
        {:error, changeset(%Radar{})}
      end)

      conn = post(conn, radar_path(conn, :create), radar: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Radar"
    end
  end

  describe "edit radar" do
    test "renders form for editing chosen radar", %{conn: conn} do
      RadarsMock
      |> expect(:change_radar, fn radar -> changeset(radar) end)
      |> expect(:get_radar!, fn id -> %Radar{id: id} end)

      conn = get(conn, radar_path(conn, :edit, %Radar{id: 1}))
      assert html_response(conn, 200) =~ "Edit Radar"
    end
  end

  describe "update radar" do
    test "redirects when data is valid", %{conn: conn} do
      RadarsMock
      |> expect(:update_radar, fn radar, _params -> {:ok, radar} end)
      |> expect(:get_radar!, fn id -> %Radar{id: id} end)

      conn = put(conn, radar_path(conn, :update, %Radar{id: 1}), radar: @update_attrs)
      assert redirected_to(conn) == radar_path(conn, :show, %Radar{id: 1})
    end

    test "renders errors when data is invalid", %{conn: conn} do
      RadarsMock
      |> expect(:update_radar, fn radar, params -> {:error, changeset(radar, params)} end)
      |> expect(:get_radar!, fn id -> %Radar{id: id} end)

      conn = put(conn, radar_path(conn, :update, %Radar{id: 1}), radar: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Radar"
    end
  end

  describe "delete radar" do
    test "deletes chosen radar", %{conn: conn} do
      RadarsMock
      |> expect(:delete_radar, fn radar -> {:ok, radar} end)
      |> expect(:get_radar!, fn id -> %Radar{id: id} end)

      conn = delete(conn, radar_path(conn, :delete, %Radar{id: 1}))
      assert redirected_to(conn) == radar_path(conn, :index)
    end
  end
end
