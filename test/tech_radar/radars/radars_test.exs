defmodule TechRadar.RadarsTest do
  use TechRadar.DataCase

  alias TechRadar.Radars

  describe "trends" do
    alias TechRadar.Radars.Trend

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    def trend_fixture(attrs \\ %{}) do
      {:ok, trend} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Radars.create_trend()

      trend
    end

    test "list_trends/0 returns all trends" do
      trend = trend_fixture()
      assert Radars.list_trends() == [trend]
    end

    test "get_trend!/1 returns the trend with given id" do
      trend = trend_fixture()
      assert Radars.get_trend!(trend.id) == trend
    end

    test "create_trend/1 with valid data creates a trend" do
      assert {:ok, %Trend{} = trend} = Radars.create_trend(@valid_attrs)
      assert trend.description == "some description"
      assert trend.name == "some name"
    end

    test "create_trend/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Radars.create_trend(@invalid_attrs)
    end

    test "update_trend/2 with valid data updates the trend" do
      trend = trend_fixture()
      assert {:ok, trend} = Radars.update_trend(trend, @update_attrs)
      assert %Trend{} = trend
      assert trend.description == "some updated description"
      assert trend.name == "some updated name"
    end

    test "update_trend/2 with invalid data returns error changeset" do
      trend = trend_fixture()
      assert {:error, %Ecto.Changeset{}} = Radars.update_trend(trend, @invalid_attrs)
      assert trend == Radars.get_trend!(trend.id)
    end

    test "delete_trend/1 deletes the trend" do
      trend = trend_fixture()
      assert {:ok, %Trend{}} = Radars.delete_trend(trend)
      assert_raise Ecto.NoResultsError, fn -> Radars.get_trend!(trend.id) end
    end

    test "change_trend/1 returns a trend changeset" do
      trend = trend_fixture()
      assert %Ecto.Changeset{} = Radars.change_trend(trend)
    end
  end

  describe "radars" do
    alias TechRadar.Radars.Radar

    @valid_attrs %{
      category_1_name: "some category_1_name",
      category_2_name: "some category_2_name",
      category_3_name: "some category_3_name",
      category_4_name: "some category_4_name",
      innermost_level_name: "some innermost_level_name",
      intro: "some intro",
      level_2_name: "some level_2_name",
      level_3_name: "some level_3_name",
      name: "some name",
      outermost_level_name: "some outermost_level_name",
      radar_trends: []
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
      outermost_level_name: "some updated outermost_level_name",
      radar_trends: []
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
      outermost_level_name: nil,
      radar_trends: nil
    }

    def radar_fixture(attrs \\ %{}) do
      {:ok, radar} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Radars.create_radar()

      radar
    end

    test "list_radars/0 returns all radars" do
      radar = radar_fixture()
      assert Radars.list_radars() == [radar]
    end

    test "get_radar!/1 returns the radar with given id" do
      radar = radar_fixture()
      assert Radars.get_radar!(radar.id) == radar
    end

    test "create_radar/1 with valid data creates a radar" do
      assert {:ok, %Radar{} = radar} = Radars.create_radar(@valid_attrs)
      assert radar.category_1_name == "some category_1_name"
      assert radar.category_2_name == "some category_2_name"
      assert radar.category_3_name == "some category_3_name"
      assert radar.category_4_name == "some category_4_name"
      assert radar.innermost_level_name == "some innermost_level_name"
      assert radar.intro == "some intro"
      assert radar.level_2_name == "some level_2_name"
      assert radar.level_3_name == "some level_3_name"
      assert radar.name == "some name"
      assert radar.outermost_level_name == "some outermost_level_name"
    end

    test "create_radar/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Radars.create_radar(@invalid_attrs)
    end

    test "update_radar/2 with valid data updates the radar" do
      radar = radar_fixture()
      assert {:ok, radar} = Radars.update_radar(radar, @update_attrs)
      assert %Radar{} = radar
      assert radar.category_1_name == "some updated category_1_name"
      assert radar.category_2_name == "some updated category_2_name"
      assert radar.category_3_name == "some updated category_3_name"
      assert radar.category_4_name == "some updated category_4_name"
      assert radar.innermost_level_name == "some updated innermost_level_name"
      assert radar.intro == "some updated intro"
      assert radar.level_2_name == "some updated level_2_name"
      assert radar.level_3_name == "some updated level_3_name"
      assert radar.name == "some updated name"
      assert radar.outermost_level_name == "some updated outermost_level_name"
    end

    test "update_radar/2 with invalid data returns error changeset" do
      radar = radar_fixture()
      assert {:error, %Ecto.Changeset{}} = Radars.update_radar(radar, @invalid_attrs)
      assert radar == Radars.get_radar!(radar.id)
    end

    test "delete_radar/1 deletes the radar" do
      radar = radar_fixture()
      assert {:ok, %Radar{}} = Radars.delete_radar(radar)
      assert_raise Ecto.NoResultsError, fn -> Radars.get_radar!(radar.id) end
    end

    test "change_radar/1 returns a radar changeset" do
      radar = radar_fixture()
      assert %Ecto.Changeset{} = Radars.change_radar(radar)
    end
  end
end
