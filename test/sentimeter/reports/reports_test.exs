defmodule Sentimeter.ReportsTest do
  use Sentimeter.DataCase
  import Mox
  alias Sentimeter.SurveysMock
  alias Sentimeter.ResponsesMock
  alias Sentimeter.Reports.ReportsImpl, as: Reports
  alias Sentimeter.Reports.ReportTrend
  alias Sentimeter.Reports.Distribution
  alias Sentimeter.Responses.Response
  alias Sentimeter.Fixtures

  setup :verify_on_exit!

  describe "get_report_by_survey_guid!/1" do
    setup do
      survey = Fixtures.survey()

      trends =
        1..4
        |> Enum.map(fn n ->
          Fixtures.trend(%{name: "name#{n}", description: "description#{n}"})
        end)

      survey_trends =
        trends
        |> Enum.map(fn trend ->
          Fixtures.survey_trend(%{survey_id: survey.id, trend_id: trend.id})
        end)
        |> Repo.preload(:trend)

      responses =
        1..4
        |> Enum.map(fn n ->
          Fixtures.response(%{survey_guid: survey.guid, email: "applesauce#{n}@gmail.com"})
        end)

      answers =
        survey_trends
        |> Enum.with_index(1)
        |> Enum.map(fn {survey_trend, i} ->
          responses
          |> Enum.with_index()
          |> Enum.filter(fn {response, j} -> j < i end)
          |> Enum.map(fn {response, j} ->
            thoughts = if rem(j, 2) == 0, do: "lorum ipsum", else: nil

            would_recommend =
              case rem(j, 3) do
                0 -> "yes"
                1 -> "no"
                _ -> "unsure"
              end

            Fixtures.answer(%{
              response_id: response.id,
              survey_trend_guid: survey_trend.guid,
              x: j + 1,
              y: i,
              thoughts: thoughts,
              would_recommend: would_recommend
            })
          end)
        end)

      SurveysMock
      |> expect(:get_survey_by_guid!, fn guid ->
        assert guid == survey.guid
        survey
      end)

      SurveysMock
      |> expect(:get_trends_by_survey_guid, fn guid ->
        assert guid == survey.guid

        survey_trends
        |> Enum.map(fn survey_trend -> {survey_trend.guid, survey_trend.trend} end)
        |> Map.new()
      end)

      ResponsesMock
      |> expect(:responses_for_survey_guid, fn guid ->
        assert guid == survey.guid
        Repo.all(Response) |> Repo.preload(:answers)
      end)

      %{
        survey: survey,
        trends: trends,
        survey_trends: survey_trends,
        responses: responses,
        answers: answers
      }
    end

    test "copies top level fields from the survey", %{survey: survey} do
      report = Reports.get_report_by_survey_guid!(survey.guid)
      assert report.name == survey.name
      assert report.x_max_label == survey.x_max_label
      assert report.x_min_label == survey.x_min_label
      assert report.y_max_label == survey.y_max_label
      assert report.y_min_label == survey.y_min_label
    end

    test "counts responses correctly", %{survey: survey, responses: responses} do
      report = Reports.get_report_by_survey_guid!(survey.guid)
      assert report.response_count == length(responses)
    end

    test "generates the right number of report trends", %{survey: survey, trends: trends} do
      report = Reports.get_report_by_survey_guid!(survey.guid)
      assert length(report.report_trends) == length(trends)
    end

    test "trends have the right name & description", %{survey: survey, trends: trends} do
      report = Reports.get_report_by_survey_guid!(survey.guid)

      trends
      |> Enum.each(fn trend ->
        report_trend =
          report.report_trends
          |> Enum.find(fn report_trend ->
            report_trend.name == trend.name
          end)

        assert %ReportTrend{} = report_trend
        assert report_trend.description == trend.description
      end)
    end

    test "sums influential count & recommend_count correctly", %{
      survey: survey,
      survey_trends: survey_trends
    } do
      report = Reports.get_report_by_survey_guid!(survey.guid)

      survey_trends
      |> Enum.with_index(1)
      |> Enum.each(fn {survey_trend, i} ->
        report_trend =
          report.report_trends
          |> Enum.find(fn report_trend ->
            report_trend.name == survey_trend.trend.name
          end)

        assert %ReportTrend{} = report_trend
        # per setup, number of answers ascend by report trend
        assert report_trend.influential == i
        expected_would_recommend = if i == 4, do: 2, else: 1
        assert report_trend.would_recommend == expected_would_recommend
      end)
    end

    test "plots correctly", %{
      survey: survey,
      survey_trends: survey_trends
    } do
      report = Reports.get_report_by_survey_guid!(survey.guid)

      # values get normalized to the overall range
      plots = [{0, 0}, {0.333, 0.333}, {0.667, 0.667}, {1.0, 1.0}]

      survey_trends
      |> Enum.zip(plots)
      |> Enum.with_index(1)
      |> Enum.each(fn {{survey_trend, {x_plot, y_plot}}, i} ->
        report_trend =
          report.report_trends
          |> Enum.find(fn report_trend ->
            report_trend.name == survey_trend.trend.name
          end)

        assert %ReportTrend{} = report_trend
        assert abs(report_trend.x_plot - x_plot) < 0.001
        assert abs(report_trend.y_plot - y_plot) < 0.001
      end)
    end

    test "distributes correctly", %{
      survey: survey,
      survey_trends: survey_trends
    } do
      report = Reports.get_report_by_survey_guid!(survey.guid)

      x_distributions = [
        %Distribution{
          lower_extreme: 1,
          lower_quartile: 1,
          median: 1,
          upper_quartile: 1,
          upper_extreme: 1
        },
        %Distribution{
          lower_extreme: 1,
          lower_quartile: 1,
          median: 1.5,
          upper_quartile: 2,
          upper_extreme: 2
        },
        %Distribution{
          lower_extreme: 1,
          lower_quartile: 1,
          median: 2,
          upper_quartile: 3,
          upper_extreme: 3
        },
        %Distribution{
          lower_extreme: 1,
          lower_quartile: 1.5,
          median: 2.5,
          upper_quartile: 3.5,
          upper_extreme: 4
        }
      ]

      survey_trends
      |> Enum.zip(x_distributions)
      |> Enum.with_index(1)
      |> Enum.each(fn {{survey_trend, x_distribution}, i} ->
        report_trend =
          report.report_trends
          |> Enum.find(fn report_trend ->
            report_trend.name == survey_trend.trend.name
          end)

        assert %ReportTrend{} = report_trend

        assert %Distribution{} = report_trend.x_axis_distribution
        assert report_trend.x_axis_distribution.lower_extreme == x_distribution.lower_extreme
        assert report_trend.x_axis_distribution.lower_quartile == x_distribution.lower_quartile
        assert report_trend.x_axis_distribution.median == x_distribution.median
        assert report_trend.x_axis_distribution.upper_quartile == x_distribution.upper_quartile
        assert report_trend.x_axis_distribution.upper_extreme == x_distribution.upper_extreme
      end)
    end

    test "sets up responses correctly", %{
      survey: survey,
      survey_trends: survey_trends,
      responses: responses
    } do
      report = Reports.get_report_by_survey_guid!(survey.guid)

      survey_trends
      |> Enum.with_index(1)
      |> Enum.each(fn {survey_trend, i} ->
        report_trend =
          report.report_trends
          |> Enum.find(fn report_trend ->
            report_trend.name == survey_trend.trend.name
          end)

        assert %ReportTrend{} = report_trend

        assert length(report_trend.responses) == div(i + 1, 2)

        report_trend.responses
        |> Enum.each(fn response ->
          matching_response =
            responses
            |> Enum.find(fn test ->
              response.email == test.email
            end)

          assert %Response{} = matching_response
          assert response.thoughts == "lorum ipsum"
        end)
      end)
    end
  end
end
