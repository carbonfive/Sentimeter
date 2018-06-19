defmodule TechRadarWeb.SurveyResponseControllerTest do
  use TechRadarWeb.ConnCase

  alias TechRadar.Surveys.SurveysImpl, as: Surveys
  alias TechRadar.RadarsMock
  import TechRadar.Factory
  import Mox

  describe "edit survey_response" do
    setup [:create_survey_response]

    test "renders form for editing chosen survey_response", %{
      conn: conn,
      survey_response: survey_response
    } do
      conn = get(conn, survey_response_path(conn, :edit, survey_response))
      assert html_response(conn, 200) =~ "Edit Survey response"
    end
  end

  describe "update survey_response" do
    setup [:create_survey_response]

    test "redirects when data is valid", %{
      conn: conn,
      survey_response: survey_response,
      update_attrs: update_attrs
    } do
      conn =
        put(
          conn,
          survey_response_path(conn, :update, survey_response),
          survey: update_attrs
        )

      assert redirected_to(conn) == survey_response_path(conn, :show, survey_response)

      conn = get(conn, survey_response_path(conn, :show, survey_response))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      survey_response: survey_response,
      invalid_attrs: invalid_attrs
    } do
      conn =
        put(
          conn,
          survey_response_path(conn, :update, survey_response),
          survey: invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Survey response"
    end
  end

  defp create_survey_response(_) do
    radar = insert(:radar)

    radar_trends = [
      insert(:radar_trend, category: 1, radar: radar),
      insert(:radar_trend, category: 1, radar: radar)
    ]

    RadarsMock
    |> stub(:get_radar_by_guid!, fn _ -> radar end)
    |> stub(:get_trends_by_radar_guid, fn _ ->
      %{
        1 =>
          radar_trends
          |> Enum.map(fn radar_trend -> {radar_trend.guid, radar_trend.trend} end)
          |> Map.new()
      }
    end)

    {:ok, survey_response} =
      Surveys.create_survey_response(%{
        radar_guid: radar.guid,
        survey_answers:
          radar_trends
          |> Enum.with_index(1)
          |> Enum.map(fn {radar_trend, answer} ->
            %{radar_trend_guid: radar_trend.guid, answer: answer}
          end)
      })

    update_attrs = %{
      radar_guid: radar.guid,
      category_1_questions:
        survey_response.survey_answers
        |> Enum.map(fn survey_answer ->
          %{
            id: survey_answer.id,
            radar_trend_guid: survey_answer.radar_trend_guid,
            answer: survey_answer.answer + 1
          }
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
     survey_response: survey_response, update_attrs: update_attrs, invalid_attrs: invalid_attrs}
  end
end
