defmodule SentimeterWeb.Api.ReportView do
  use SentimeterWeb, :view
  alias SentimeterWeb.Api.ReportView

  def render("show.json", %{report: report}) do
    %{data: render_one(report, ReportView, "report.json")}
  end

  def render("report.json", %{report: report}) do
    report
  end
end
