defmodule SentimeterWeb.ReportControllerTest do
  use SentimeterWeb.ConnCase
  import Mox

  @guid "7488a646-e31f-11e4-aace-600308960662"

  alias Sentimeter.ReportsMock
  alias Sentimeter.Reports.Report

  describe "show" do
    test "lists a report", %{conn: conn} do
      ReportsMock |> expect(:get_report_by_survey_guid!, fn _ -> %Report{} end)
      conn = get(conn, Routes.report_path(conn, :show, @guid))
      assert html_response(conn, 200) =~ "<div id=\"root\">"
    end
  end
end
