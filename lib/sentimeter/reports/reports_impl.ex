defmodule Sentimeter.Reports.ReportsImpl do
  @moduledoc """
  The Reports context.
  """
  @behaviour Sentimeter.Reports
  alias Sentimeter.Reports.Report
  import Ecto.Changeset
  @surveys Application.get_env(:sentimeter, :surveys)
  @responses Application.get_env(:sentimeter, :responses)
  @doc """
  Gets a single report.

  Raises if the Report does not exist.

  ## Examples

      iex> get_report!(123)
      %Report{}

  """
  def get_report_by_survey_guid!(survey_guid) do
    survey = @surveys.get_survey_by_guid!(survey_guid)
    responses = @responses.responses_for_survey_guid(survey_guid)
    trends_by_survey_trend_guid = @surveys.get_trends_by_survey_guid(survey_guid)

    report_trends =
      trends_by_survey_trend_guid
      |> trends_with_response_answer_pairs(responses)
      |> Enum.map(fn {trend, response_answer_pairs} ->
        %{
          name: trend.name,
          description: trend.description,
          influential: length(response_answer_pairs),
          would_recommend: would_recommend(response_answer_pairs),
          x_plot: x_plot(response_answer_pairs),
          y_plot: y_plot(response_answer_pairs),
          x_axis_distribution: x_axis_distribution(response_answer_pairs),
          y_axis_distribution: y_axis_distribution(response_answer_pairs),
          responses: responses(response_answer_pairs)
        }
      end)

    normalized_trends = normalize_report_trends(report_trends)

    report_changes =
      %Report{}
      |> Report.changeset(%{
        name: survey.name,
        x_max_label: survey.x_max_label,
        x_min_label: survey.x_min_label,
        y_max_label: survey.y_max_label,
        y_min_label: survey.y_min_label,
        response_count: length(responses),
        report_trends: normalized_trends
      })

    if report_changes.valid? do
      report_changes |> apply_changes()
    else
      raise(Ecto.InvalidChangesetError, action: "insert", changeset: report_changes)
    end
  end

  defp trends_with_response_answer_pairs(trends_by_survey_trend_guid, responses) do
    responses_with_mapped_survey_guids =
      responses
      |> Enum.map(fn response ->
        {response,
         response.answers
         |> Enum.map(fn answer ->
           {answer.survey_trend_guid, answer}
         end)
         |> Map.new()}
      end)

    trends_by_survey_trend_guid
    |> Enum.map(fn {survey_trend_guid, trend} ->
      {trend,
       responses_with_mapped_survey_guids
       |> Enum.map(fn {response, answers_by_survey_guid} ->
         {response, Map.get(answers_by_survey_guid, survey_trend_guid)}
       end)
       |> Enum.filter(fn {_, answer} -> answer != nil end)}
    end)
  end

  defp normalize_report_trends(report_trends) do
    x_min = report_trends |> Enum.map(& &1[:x_plot]) |> Enum.min()
    x_max = report_trends |> Enum.map(& &1[:x_plot]) |> Enum.max()
    y_min = report_trends |> Enum.map(& &1[:y_plot]) |> Enum.min()
    y_max = report_trends |> Enum.map(& &1[:y_plot]) |> Enum.max()

    report_trends
    |> Enum.map(fn report_trend ->
      Map.merge(report_trend, %{
        x_plot: normalize(report_trend[:x_plot], x_min, x_max),
        y_plot: normalize(report_trend[:y_plot], y_min, y_max)
      })
    end)
  end

  defp normalize(val, min, max) when min == max do
    (val - 1) / 4
  end

  defp normalize(val, min, max) do
    (val - min) / (max - min)
  end

  defp plot(vals) when length(vals) == 0 do
    0
  end

  defp plot(vals) do
    Enum.sum(vals) / length(vals)
  end

  defp distribution(vals) when length(vals) == 0 do
    %{
      lower_extreme: 1,
      lower_quartile: 1,
      median: 1,
      upper_quartile: 1,
      upper_extreme: 1
    }
  end

  defp distribution(vals) do
    sorted_vals = vals |> Enum.sort()
    median_elem = median(sorted_vals)
    {lower_vals, upper_vals} = median_split(sorted_vals)
    lower_quartile = median(lower_vals)
    upper_quartile = median(upper_vals)
    [lower_extreme | _] = sorted_vals
    [upper_extreme | _] = sorted_vals |> Enum.reverse()

    %{
      lower_extreme: lower_extreme,
      lower_quartile: lower_quartile,
      median: median_elem,
      upper_quartile: upper_quartile,
      upper_extreme: upper_extreme
    }
  end

  defp median(list) do
    median(length(list), list)
  end

  defp median(total, list) when rem(total, 2) == 0 do
    median_top = div(total, 2)
    median_bottom = median_top - 1
    tuple_list = list |> List.to_tuple()
    (elem(tuple_list, median_bottom) + elem(tuple_list, median_top)) / 2.0
  end

  defp median(total, list) when rem(total, 2) == 1 do
    median_index = div(total, 2)
    tuple_list = list |> List.to_tuple()
    elem(tuple_list, median_index)
  end

  defp median_split(list) do
    median_split(length(list), list)
  end

  defp median_split(total, list) when rem(total, 2) == 0 do
    median_top = div(total, 2)
    Enum.split(list, median_top)
  end

  defp median_split(total, list) when rem(total, 2) == 1 do
    median_index = div(total, 2)
    lower = if median_index == 0, do: 0, else: median_index - 1
    upper = if median_index == 0, do: 0, else: median_index + 1
    {Enum.slice(list, 0..lower), Enum.slice(list, upper..-1)}
  end

  defp x_vals(answers) do
    answers |> Enum.map(& &1.x)
  end

  defp y_vals(answers) do
    answers |> Enum.map(& &1.y)
  end

  defp x_plot(response_answer_pairs) do
    response_answer_pairs |> answers_only |> x_vals |> plot
  end

  defp y_plot(response_answer_pairs) do
    response_answer_pairs |> answers_only |> y_vals |> plot
  end

  defp x_axis_distribution(response_answer_pairs) do
    response_answer_pairs |> answers_only |> x_vals |> distribution
  end

  defp y_axis_distribution(response_answer_pairs) do
    response_answer_pairs |> answers_only |> y_vals |> distribution
  end

  defp answers_only(response_answer_pairs) do
    response_answer_pairs |> Enum.map(fn {_, answer} -> answer end)
  end

  defp would_recommend(response_answer_pairs) do
    response_answer_pairs
    |> answers_only
    |> Enum.filter(fn answer ->
      answer.would_recommend == :yes
    end)
    |> length()
  end

  defp responses(response_answer_pairs) do
    response_answer_pairs
    |> Enum.filter(fn {_, answer} -> answer.thoughts != nil end)
    |> Enum.map(fn {response, answer} ->
      %{
        email: response.email,
        thoughts: answer.thoughts
      }
    end)
  end
end
