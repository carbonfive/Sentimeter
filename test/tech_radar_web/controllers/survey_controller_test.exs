defmodule TechRadarWeb.SurveyControllerTest do
  use TechRadarWeb.ConnCase

  alias TechRadar.RadarsMock
  import TechRadar.Factory
  import Mox

  setup do
    radar = insert(:radar)

    radar_trends = [
      insert(:radar_trend, category: 1, radar: radar),
      insert(:radar_trend, category: 1, radar: radar)
    ]

    RadarsMock
    |> expect(:get_radar_by_guid!, fn _ -> radar end)
    |> expect(:get_trends_by_radar_guid, fn _ ->
      %{
        1 =>
          radar_trends
          |> Enum.map(fn radar_trend -> {radar_trend.guid, radar_trend.trend} end)
          |> Map.new()
      }
    end)

    create_attrs = %{
      radar_guid: radar.guid,
      category_1_questions:
        radar_trends
        |> Enum.with_index(1)
        |> Enum.map(fn {radar_trend, answer} ->
          %{radar_trend_guid: radar_trend.guid, answer: answer}
        end),
      category_2_questions: [],
      category_3_questions: [],
      category_4_questions: []
    }

    invalid_attrs = %{
      radar_guid: nil,
      category_1_questions: nil,
      category_2_questions: [],
      category_3_questions: [],
      category_4_questions: []
    }

    {:ok,
     radar: radar,
     radar_trends: radar_trends,
     create_attrs: create_attrs,
     invalid_attrs: invalid_attrs}
  end

  describe "create a survey_response from a survey" do
    test "redirects to show when data is valid", %{conn: conn, create_attrs: create_attrs} do
      conn = post(conn, survey_path(conn, :create), survey: create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == survey_response_path(conn, :show, id)

      conn = get(conn, survey_response_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Survey response"
    end

    test "renders errors when data is invalid", %{conn: conn, invalid_attrs: invalid_attrs} do
      conn = post(conn, survey_path(conn, :create), survey: invalid_attrs)
      assert html_response(conn, 200) =~ "Oops, something went wrong!"
    end
  end
end
