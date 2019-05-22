defmodule SentimeterWeb.ReportController do
  use SentimeterWeb, :controller
  plug SentimeterWeb.Plug.AllowIframe

  def show(conn, %{"guid" => guid}) do
    conn = assign(conn, :dark, true)

    conn
    |> put_layout("report.html")
    |> render("show.html")
  end
end
