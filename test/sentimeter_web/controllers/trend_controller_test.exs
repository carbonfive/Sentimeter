defmodule SentimeterWeb.TrendControllerTest do
  use SentimeterWeb.ConnCase
  import Mox
  alias Sentimeter.SurveysMock
  alias Sentimeter.Surveys.Trend
  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def changeset(%Trend{} = trend, attrs \\ %{}) do
    Ecto.Changeset.change(trend, attrs)
  end

  setup :verify_on_exit!

  describe "index" do
    test "lists all trends", %{conn: conn} do
      SurveysMock |> expect(:list_trends, fn -> [] end)
      conn = get(conn, Routes.trend_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Trends"
    end
  end

  describe "new trend" do
    test "renders form", %{conn: conn} do
      SurveysMock |> expect(:change_trend, 1, fn trend -> changeset(trend) end)
      conn = get(conn, Routes.trend_path(conn, :new))
      assert html_response(conn, 200) =~ "New Trend"
    end
  end

  describe "create trend" do
    test "redirects to show when data is valid", %{conn: conn} do
      SurveysMock |> expect(:create_trend, fn _ -> {:ok, %Trend{id: 1}} end)
      conn = post(conn, Routes.trend_path(conn, :create), trend: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.trend_path(conn, :show, id)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      SurveysMock
      |> expect(:create_trend, fn _ ->
        {:error, changeset(%Trend{})}
      end)

      conn = post(conn, Routes.trend_path(conn, :create), trend: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Trend"
    end
  end

  describe "edit trend" do
    test "renders form for editing chosen trend", %{conn: conn} do
      SurveysMock
      |> expect(:change_trend, fn trend -> changeset(trend) end)
      |> expect(:get_trend!, fn id -> %Trend{id: id} end)

      conn = get(conn, Routes.trend_path(conn, :edit, %Trend{id: 1}))
      assert html_response(conn, 200) =~ "Edit Trend"
    end
  end

  describe "update trend" do
    test "redirects when data is valid", %{conn: conn} do
      SurveysMock
      |> expect(:update_trend, fn trend, _params -> {:ok, trend} end)
      |> expect(:get_trend!, fn id -> %Trend{id: id} end)

      conn = put(conn, Routes.trend_path(conn, :update, %Trend{id: 1}), trend: @update_attrs)
      assert redirected_to(conn) == Routes.trend_path(conn, :show, %Trend{id: 1})
    end

    test "renders errors when data is invalid", %{conn: conn} do
      SurveysMock
      |> expect(:update_trend, fn trend, params -> {:error, changeset(trend, params)} end)
      |> expect(:get_trend!, fn id -> %Trend{id: id} end)

      conn = put(conn, Routes.trend_path(conn, :update, %Trend{id: 1}), trend: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Trend"
    end
  end

  describe "delete trend" do
    test "deletes chosen trend", %{conn: conn} do
      SurveysMock
      |> expect(:delete_trend, fn trend -> {:ok, trend} end)
      |> expect(:get_trend!, fn id -> %Trend{id: id} end)

      conn = delete(conn, Routes.trend_path(conn, :delete, %Trend{id: 1}))
      assert redirected_to(conn) == Routes.trend_path(conn, :index)
    end
  end
end
