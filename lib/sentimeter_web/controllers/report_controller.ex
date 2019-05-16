defmodule SentimeterWeb.ReportController do
  use SentimeterWeb, :controller

  @reports Application.get_env(:sentimeter, :reports)

  def show(conn, %{"guid" => guid}) do
    conn = assign(conn, :dark, true)

    report = @reports.get_report_by_survey_guid!(guid)

    conn
    |> put_layout("report.html")
    |> render("show.html", report: report)
  end
end
