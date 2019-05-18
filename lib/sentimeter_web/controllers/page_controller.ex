defmodule SentimeterWeb.PageController do
  use SentimeterWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
