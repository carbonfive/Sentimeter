defmodule SentimeterWeb.ReportControllerTest do
  use SentimeterWeb.ConnCase

  @guid "7488a646-e31f-11e4-aace-600308960662"

  describe "show" do
    test "lists a report", %{conn: conn} do
      conn = get(conn, Routes.report_path(conn, :show, @guid))
      assert html_response(conn, 200) =~ "<div id=\"root\">"
    end
  end
end
