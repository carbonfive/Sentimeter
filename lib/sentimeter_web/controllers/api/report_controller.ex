defmodule SentimeterWeb.Api.ReportController do
  use SentimeterWeb, :controller

  @reports Application.get_env(:sentimeter, :reports)

  action_fallback SentimeterWeb.FallbackController

  def show(conn, %{"guid" => guid}) do
    report = @reports.get_report_by_survey_guid!(guid)
    render(conn, "show.json", report: report)
  end
end
