defmodule TechRadarWeb.PageController do
  use TechRadarWeb, :controller

  def index(conn, _params) do
    conn
    |> render("index.html")
  end
end
