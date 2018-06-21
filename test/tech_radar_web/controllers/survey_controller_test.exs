defmodule TechRadarWeb.SurveyControllerTest do
  use TechRadarWeb.ConnCase

  alias TechRadar.SurveysMock
  import TechRadar.Factory
  import Mox
  alias TechRadar.Surveys.SurveyResponse
  alias TechRadar.Surveys.Survey

  @radar_guid "ABCD-123"
  @create_attrs %{
      radar_guid: @radar_guid,
      category_1_questions: [],
      category_2_questions: [],
      category_3_questions: [],
      category_4_questions: []
  }

  @invalid_attrs %{
      radar_guid: nil,
      category_1_questions: nil,
      category_2_questions: [],
      category_3_questions: [],
      category_4_questions: []
  }

  describe "create a survey_response from a survey" do
    test "redirects to show when data is valid", %{conn: conn} do
      SurveysMock |> expect(:create_survey_response_from_survey, fn _params -> {:ok, %SurveyResponse{id: 1}} end)
      conn = post(conn, survey_path(conn, :create), survey: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == survey_response_path(conn, :show, id)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      SurveysMock |> expect(:create_survey_response_from_survey, fn params -> Survey.changeset(%Survey{}, params) |> Ecto.Changeset.apply_action(:insert) end)

      conn = post(conn, survey_path(conn, :create), survey: @invalid_attrs)
      assert html_response(conn, 200) =~ "Oops, something went wrong!"
    end
  end
end
