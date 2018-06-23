defmodule TechRadarWeb.Api.ReportController do
  use TechRadarWeb, :controller

  alias TechRadar.Reports
  alias TechRadar.Reports.Report

  action_fallback(TechRadarWeb.FallbackController)

  def show(conn, %{"guid" => guid}) do
    report = Reports.report_from_radar_guid!(guid)
    render(conn, "show.json", report: report)
  end
end
