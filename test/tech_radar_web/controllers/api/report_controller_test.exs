defmodule TechRadarWeb.Api.ReportControllerTest do
  use TechRadarWeb.ConnCase

  import TechRadar.Factory
  import Mox
  alias TechRadar.Reports
  alias TechRadar.RadarsMock
  alias TechRadar.SurveysMock
  @create_attrs %{radar_guid: "7488a646-e31f-11e4-aace-600308960662"}
  @update_attrs %{radar_guid: "7488a646-e31f-11e4-aace-600308960668"}
  @invalid_attrs %{radar_guid: nil}

  setup do
    radar = insert(:radar)

    trends_by_category =
      [1, 2, 3, 4]
      |> Enum.map(fn num ->
        {num,
         [
           insert(:radar_trend, category: num, radar: radar),
           insert(:radar_trend, category: num, radar: radar)
         ]}
      end)
      |> Enum.into(%{})

    radar_trends_by_category_and_guid =
      trends_by_category
      |> Enum.map(fn {num, radar_trends} ->
        {num,
         radar_trends
         |> Enum.map(fn radar_trend -> {radar_trend.guid, radar_trend.trend} end)
         |> Map.new()}
      end)
      |> Map.new()

    RadarsMock
    |> expect(:get_radar_by_guid!, fn _ -> radar end)
    |> expect(:get_trends_by_radar_guid, fn _ ->
      radar_trends_by_category_and_guid
    end)

    survey_responses =
      [1, 2]
      |> Enum.map(fn num ->
        insert(
          :survey_response,
          survey_answers:
            Map.values(trends_by_category)
            |> List.flatten()
            |> Enum.map(fn radar_trend ->
              build(
                :survey_answer,
                answer: num,
                radar_trend_guid: radar_trend.guid
              )
            end)
        )
      end)

    SurveysMock
    |> expect(:get_survey_responses_for_radar_guid, fn _ -> survey_responses end)

    {:ok,
     radar: radar,
     trends_by_category: trends_by_category,
     radar_trends_by_category_and_guid: radar_trends_by_category_and_guid,
     survey_responses: survey_responses}
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "show" do
    test "lists all reports", %{conn: conn, radar: radar} do
      conn = get(conn, report_path(conn, :show, radar.guid))
      refute json_response(conn, 200)["data"] == nil
    end
  end
end
