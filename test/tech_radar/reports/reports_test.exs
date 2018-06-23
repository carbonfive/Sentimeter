defmodule TechRadar.ReportsTest do
  use TechRadar.DataCase

  import TechRadar.Factory
  import Mox
  alias TechRadar.Reports
  alias TechRadar.RadarsMock
  alias TechRadar.SurveysMock

  describe "reports" do
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

    test "report_from_radar_guid!/1 returns the report assembled from data for a radar", %{
      radar: radar,
      radar_trends_by_category_and_guid: radar_trends_by_category_and_guid,
      survey_responses: survey_responses
    } do
      report = Reports.report_from_radar_guid!(radar.guid)
      assert report.radar_guid == radar.guid
      assert report.category_1_name == radar.category_1_name
      assert report.category_2_name == radar.category_2_name
      assert report.category_3_name == radar.category_3_name
      assert report.category_4_name == radar.category_4_name
      assert report.innermost_level_name == radar.innermost_level_name
      assert report.intro == radar.intro
      assert report.level_2_name == radar.level_2_name
      assert report.level_3_name == radar.level_3_name
      assert report.name == radar.name
      assert report.outermost_level_name == radar.outermost_level_name

      assert length(report.report_trends) > 0

      report.report_trends
      |> Enum.each(fn report_trend ->
        matching_trend =
          Map.get(radar_trends_by_category_and_guid, report_trend.category, nil)
          |> Map.get(report_trend.radar_trend_guid, nil)

        refute matching_trend == nil
        assert matching_trend.name == report_trend.name
        assert matching_trend.description == report_trend.description
      end)

      assert length(report.responses) == length(survey_responses)

      List.zip([report.responses, survey_responses])
      |> Enum.each(fn {report_response, survey_response} ->
        assert report_response.id == survey_response.id
        assert length(report_response.response_answers) == length(survey_response.survey_answers)

        List.zip([report_response.response_answers, survey_response.survey_answers])
        |> Enum.each(fn {report_answer, survey_answer} ->
          assert report_answer.answer == survey_answer.answer
          assert report_answer.radar_trend_guid == survey_answer.radar_trend_guid
        end)
      end)

      assert length(report.report_trend_averages) > 0

      report.report_trend_averages
      |> Enum.each(fn report_trend_average ->
        assert report_trend_average.average == 1.5
      end)
    end
  end
end
