defmodule TechRadarWeb.RadarControllerTest do
  use TechRadarWeb.ConnCase

  alias TechRadar.Radars.RadarsImpl, as: Radars

  @create_attrs %{
    category_1_name: "some category_1_name",
    category_2_name: "some category_2_name",
    category_3_name: "some category_3_name",
    category_4_name: "some category_4_name",
    innermost_level_name: "some innermost_level_name",
    intro: "some intro",
    level_2_name: "some level_2_name",
    level_3_name: "some level_3_name",
    name: "some name",
    outermost_level_name: "some outermost_level_name"
  }
  @update_attrs %{
    category_1_name: "some updated category_1_name",
    category_2_name: "some updated category_2_name",
    category_3_name: "some updated category_3_name",
    category_4_name: "some updated category_4_name",
    innermost_level_name: "some updated innermost_level_name",
    intro: "some updated intro",
    level_2_name: "some updated level_2_name",
    level_3_name: "some updated level_3_name",
    name: "some updated name",
    outermost_level_name: "some updated outermost_level_name"
  }
  @invalid_attrs %{
    category_1_name: nil,
    category_2_name: nil,
    category_3_name: nil,
    category_4_name: nil,
    innermost_level_name: nil,
    intro: nil,
    level_2_name: nil,
    level_3_name: nil,
    name: nil,
    outermost_level_name: nil
  }

  def fixture(:radar) do
    {:ok, radar} = Radars.create_radar(@create_attrs)
    radar
  end

  describe "index" do
    test "lists all radars", %{conn: conn} do
      conn = get(conn, radar_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Radars"
    end
  end

  describe "new radar" do
    test "renders form", %{conn: conn} do
      conn = get(conn, radar_path(conn, :new))
      assert html_response(conn, 200) =~ "New Radar"
    end
  end

  describe "create radar" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, radar_path(conn, :create), radar: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == radar_path(conn, :show, id)

      conn = get(conn, radar_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Radar"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, radar_path(conn, :create), radar: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Radar"
    end
  end

  describe "edit radar" do
    setup [:create_radar]

    test "renders form for editing chosen radar", %{conn: conn, radar: radar} do
      conn = get(conn, radar_path(conn, :edit, radar))
      assert html_response(conn, 200) =~ "Edit Radar"
    end
  end

  describe "update radar" do
    setup [:create_radar]

    test "redirects when data is valid", %{conn: conn, radar: radar} do
      conn = put(conn, radar_path(conn, :update, radar), radar: @update_attrs)
      assert redirected_to(conn) == radar_path(conn, :show, radar)

      conn = get(conn, radar_path(conn, :show, radar))
      assert html_response(conn, 200) =~ "some updated category_1_name"
    end

    test "renders errors when data is invalid", %{conn: conn, radar: radar} do
      conn = put(conn, radar_path(conn, :update, radar), radar: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Radar"
    end
  end

  describe "delete radar" do
    setup [:create_radar]

    test "deletes chosen radar", %{conn: conn, radar: radar} do
      conn = delete(conn, radar_path(conn, :delete, radar))
      assert redirected_to(conn) == radar_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, radar_path(conn, :show, radar))
      end)
    end
  end

  defp create_radar(_) do
    radar = fixture(:radar)
    {:ok, radar: radar}
  end
end
