defmodule SentimeterWeb.ReportController do
  use SentimeterWeb, :controller

  @reports Application.get_env(:sentimeter, :reports)

  def show(conn, %{"guid" => guid}) do
    report = @reports.get_report_by_survey_guid!(guid)
    render(conn, "show.html", report: report)
  end
end
