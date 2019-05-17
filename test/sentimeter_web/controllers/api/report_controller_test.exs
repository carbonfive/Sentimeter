defmodule SentimeterWeb.Api.ReportControllerTest do
  use SentimeterWeb.ConnCase
  import Mox

  @guid "7488a646-e31f-11e4-aace-600308960662"

  alias Sentimeter.ReportsMock
  alias Sentimeter.Reports.Report
  alias Sentimeter.Reports.ReportTrend

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "show" do
    test "lists a report", %{conn: conn} do
      ReportsMock
      |> expect(:get_report_by_survey_guid!, fn _ ->
        %Report{
          report_trends: [%ReportTrend{}]
        }
      end)

      conn = get(conn, Routes.api_report_path(conn, :show, @guid))

      assert json_response(conn, 200)["data"] == %{
               "id" => nil,
               "name" => nil,
               "report_trends" => [
                 %{
                   "description" => nil,
                   "id" => nil,
                   "influential" => nil,
                   "name" => nil,
                   "responses" => [],
                   "would_recommend" => nil,
                   "x_axis_distribution" => nil,
                   "x_plot" => nil,
                   "y_axis_distribution" => nil,
                   "y_plot" => nil
                 }
               ],
               "response_count" => nil,
               "x_max_label" => nil,
               "x_min_label" => nil,
               "y_max_label" => nil,
               "y_min_label" => nil
             }
    end
  end
end
