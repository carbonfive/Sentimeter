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
end
