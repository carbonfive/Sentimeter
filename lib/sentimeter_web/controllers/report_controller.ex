defmodule SentimeterWeb.ReportController do
  use SentimeterWeb, :controller

  @reports Application.get_env(:sentimeter, :reports)

  def show(conn, %{"guid" => guid}) do
    conn = assign(conn, :dark, true)

    conn
    |> put_layout("report.html")
    |> render("show.html")
  end
end
