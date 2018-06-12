defmodule TechRadarWeb.SurveyResponseControllerTest do
  use TechRadarWeb.ConnCase

  alias TechRadar.Surveys

  @create_attrs %{
    radar_guid: "7488a646-e31f-11e4-aace-600308960662"
  }
  @update_attrs %{
    radar_guid: "7488a646-e31f-11e4-aace-600308960668"
  }
  @invalid_attrs %{radar_guid: nil}

  def fixture(:survey_response) do
    {:ok, survey_response} = Surveys.create_survey_response(@create_attrs)
    survey_response
  end

  describe "create survey_response" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, survey_response_path(conn, :create), survey_response: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == survey_response_path(conn, :show, id)

      conn = get(conn, survey_response_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Survey response"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, survey_response_path(conn, :create), survey_response: @invalid_attrs)
      assert html_response(conn, 200) =~ "Oops, something went wrong!"
    end
  end

  describe "edit survey_response" do
    setup [:create_survey_response]

    test "renders form for editing chosen survey_response", %{
      conn: conn,
      survey_response: survey_response
    } do
      conn = get(conn, survey_response_path(conn, :edit, survey_response))
      assert html_response(conn, 200) =~ "Edit Survey response"
    end
  end

  describe "update survey_response" do
    setup [:create_survey_response]

    test "redirects when data is valid", %{conn: conn, survey_response: survey_response} do
      conn =
        put(
          conn,
          survey_response_path(conn, :update, survey_response),
          survey_response: @update_attrs
        )

      assert redirected_to(conn) == survey_response_path(conn, :show, survey_response)

      conn = get(conn, survey_response_path(conn, :show, survey_response))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, survey_response: survey_response} do
      conn =
        put(
          conn,
          survey_response_path(conn, :update, survey_response),
          survey_response: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Survey response"
    end
  end

  defp create_survey_response(_) do
    survey_response = fixture(:survey_response)
    {:ok, survey_response: survey_response}
  end
end
