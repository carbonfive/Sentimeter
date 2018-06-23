defmodule TechRadar.Reports do
  alias TechRadar.Reports.Report
  alias TechRadar.Radars.Trend
  alias TechRadar.Reports.ReportTrend
  alias TechRadar.Surveys.SurveyResponse
  alias TechRadar.Reports.Response
  alias TechRadar.Reports.ResponseAnswer
  alias TechRadar.Reports.ReportTrendAverage

  @radars Application.get_env(:tech_radar, :radars)
  @surveys Application.get_env(:tech_radar, :surveys)

  @moduledoc """
  The Reports context.
  """

  @doc """
  Gets a single report from a radar guid

  Raises if the Report does not exist.

  ## Examples

      iex> get_report!(123)
      %Report{}

  """
  @spec report_from_radar_guid!(radar_guid :: Ecto.UUID) :: Report.t()
  def report_from_radar_guid!(radar_guid) do
    radar = @radars.get_radar_by_guid!(radar_guid)
    trends_by_radar_guid = @radars.get_trends_by_radar_guid(radar_guid)
    survey_responses = @surveys.get_survey_responses_for_radar_guid(radar_guid)

    %Report{
      radar_guid: radar_guid,
      category_1_name: radar.category_1_name,
      category_2_name: radar.category_2_name,
      category_3_name: radar.category_3_name,
      category_4_name: radar.category_4_name,
      innermost_level_name: radar.innermost_level_name,
      intro: radar.intro,
      level_2_name: radar.level_2_name,
      level_3_name: radar.level_3_name,
      name: radar.name,
      outermost_level_name: radar.outermost_level_name,
      report_trends: report_trends(trends_by_radar_guid),
      responses: responses(survey_responses),
      report_trend_averages: report_trend_averages(survey_responses)
    }
  end

  @spec report_trends(
          trends_by_category_and_guid :: %{optional(number) => %{optional(Ecto.UUID) => %Trend{}}}
        ) :: [%ReportTrend{}]
  defp report_trends(trends_by_category_and_guid) do
    trends_by_category_and_guid
    |> Enum.flat_map(fn {category, trends_by_guid} ->
      trends_by_guid
      |> Enum.map(fn {radar_trend_guid, trend} ->
        %ReportTrend{
          category: category,
          radar_trend_guid: radar_trend_guid,
          name: trend.name,
          description: trend.description |> Earmark.as_html!
        }
      end)
    end)
  end

  @spec responses(survey_responses :: [%SurveyResponse{}]) :: [%Response{}]
  defp responses(survey_responses) do
    survey_responses
    |> Enum.map(fn survey_response ->
      %Response{
        id: survey_response.id,
        response_answers:
          survey_response.survey_answers
          |> Enum.map(fn survey_answer ->
            %ResponseAnswer{
              radar_trend_guid: survey_answer.radar_trend_guid,
              answer: survey_answer.answer
            }
          end)
      }
    end)
  end

  @spec report_trend_averages(survey_responses :: [%SurveyResponse{}]) :: [
          %ReportTrendAverage{}
        ]
  defp report_trend_averages(survey_responses) do
    survey_responses
    |> Enum.reduce(%{}, fn survey_response, acc ->
      survey_response.survey_answers
      |> Enum.reduce(acc, fn survey_answer, acc_internal ->
        Map.update(
          acc_internal,
          survey_answer.radar_trend_guid,
          [survey_answer.answer],
          fn answers -> [survey_answer.answer | answers] end
        )
      end)
    end)
    |> Enum.map(fn {radar_trend_guid, answers} ->
      %ReportTrendAverage{
        radar_trend_guid: radar_trend_guid,
        average: (answers |> Enum.sum()) / length(answers)
      }
    end)
  end
end
