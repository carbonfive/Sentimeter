defmodule Sentimeter.TrendsTest do
  use Sentimeter.DataCase

  alias Sentimeter.Trends

  describe "trends" do
    alias Sentimeter.Trends.Trend

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def trend_fixture(attrs \\ %{}) do
      {:ok, trend} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Trends.create_trend()

      trend
    end

    test "list_trends/0 returns all trends" do
      trend = trend_fixture()
      assert Trends.list_trends() == [trend]
    end

    test "get_trend!/1 returns the trend with given id" do
      trend = trend_fixture()
      assert Trends.get_trend!(trend.id) == trend
    end

    test "create_trend/1 with valid data creates a trend" do
      assert {:ok, %Trend{} = trend} = Trends.create_trend(@valid_attrs)
      assert trend.name == "some name"
    end

    test "create_trend/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Trends.create_trend(@invalid_attrs)
    end

    test "update_trend/2 with valid data updates the trend" do
      trend = trend_fixture()
      assert {:ok, %Trend{} = trend} = Trends.update_trend(trend, @update_attrs)
      assert trend.name == "some updated name"
    end

    test "update_trend/2 with invalid data returns error changeset" do
      trend = trend_fixture()
      assert {:error, %Ecto.Changeset{}} = Trends.update_trend(trend, @invalid_attrs)
      assert trend == Trends.get_trend!(trend.id)
    end

    test "delete_trend/1 deletes the trend" do
      trend = trend_fixture()
      assert {:ok, %Trend{}} = Trends.delete_trend(trend)
      assert_raise Ecto.NoResultsError, fn -> Trends.get_trend!(trend.id) end
    end

    test "change_trend/1 returns a trend changeset" do
      trend = trend_fixture()
      assert %Ecto.Changeset{} = Trends.change_trend(trend)
    end
  end
end
