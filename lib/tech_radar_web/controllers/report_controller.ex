defmodule TechRadarWeb.ReportController do
  use TechRadarWeb, :controller
  plug(:put_layout, "report.html")

  def show(conn, %{"guid" => guid}) do
    render(conn, "show.html", guid: guid)
  end
end
