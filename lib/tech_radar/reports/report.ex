defmodule TechRadar.Reports.ReportTrend do
  alias TechRadar.Reports.ReportTrend

  @enforce_keys [:radar_trend_guid, :name, :description]
  defstruct(
    radar_trend_guid: nil,
    name: "",
    description: "",
    category: 1
  )

  @type t :: %ReportTrend{
          radar_trend_guid: Ecto.UUID,
          name: String.t(),
          description: String.t(),
          category: integer
        }
end

defmodule TechRadar.Reports.ResponseAnswer do
  alias TechRadar.Reports.ResponseAnswer

  @enforce_keys [:radar_trend_guid, :answer]
  defstruct(
    radar_trend_guid: nil,
    answer: 1
  )

  @type t :: %ResponseAnswer{radar_trend_guid: Ecto.UUID, answer: integer}
end

defmodule TechRadar.Reports.Response do
  alias TechRadar.Reports.Response
  alias TechRadar.Reports.ResponseAnswer

  @enforce_keys [:id, :response_answers]
  defstruct(
    id: nil,
    response_answers: []
  )

  @type t :: %Response{id: integer, response_answers: [ResponseAnswer.t()]}
end

defmodule TechRadar.Reports.ReportTrendAverage do
  alias TechRadar.Reports.ReportTrendAverage

  @enforce_keys [:radar_trend_guid, :average]
  defstruct(
    radar_trend_guid: nil,
    average: 1
  )

  @type t :: %ReportTrendAverage{radar_trend_guid: Ecto.UUID, average: float}
end

defmodule TechRadar.Reports.Report do
  alias TechRadar.Reports.ReportTrend
  alias TechRadar.Reports.Response
  alias TechRadar.Reports.ReportTrendAverage
  alias TechRadar.Reports.Report

  defstruct(
    radar_guid: nil,
    category_1_name: "",
    category_2_name: "",
    category_3_name: "",
    category_4_name: "",
    innermost_level_name: "",
    intro: "",
    level_2_name: "",
    level_3_name: "",
    name: "",
    outermost_level_name: "",
    report_trends: [],
    responses: [],
    report_trend_averages: []
  )

  @type t :: %Report{
          radar_guid: Ecto.UUID,
          category_1_name: String.t(),
          category_2_name: String.t(),
          category_3_name: String.t(),
          category_4_name: String.t(),
          innermost_level_name: String.t(),
          intro: String.t(),
          level_2_name: String.t(),
          level_3_name: String.t(),
          name: String.t(),
          outermost_level_name: String.t(),
          report_trends: [ReportTrend.t()],
          responses: [Response.t()],
          report_trend_averages: [ReportTrendAverage.t()]
        }
end
