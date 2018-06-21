defmodule TechRadarWeb.SurveyResponseControllerTest do
  use TechRadarWeb.ConnCase

  alias TechRadar.SurveysMock
  import TechRadar.Factory
  import Mox
  alias TechRadar.Surveys.Survey
  alias TechRadar.Surveys.SurveyResponse

  @radar_guid "ABCD-123"
  @update_attrs %{
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

  def changeset(%Survey{} = survey, attrs \\ %{}) do
    Ecto.Changeset.change(survey, attrs)
  end

  describe "edit survey_response" do
    test "renders form for editing chosen survey_response", %{conn: conn} do
      SurveysMock
      |> expect(:change_survey, fn survey -> changeset(survey) end)
      |> expect(:get_survey_response!, fn id ->
        %SurveyResponse{id: id, radar_guid: @radar_guid}
      end)
      |> expect(:survey_from_survey_response!, fn survey_response ->
        %Survey{radar_guid: survey_response.radar_guid}
      end)

      conn = get(conn, survey_response_path(conn, :edit, %SurveyResponse{id: 1}))
      assert html_response(conn, 200) =~ "Edit Survey response"
    end
  end

  describe "update survey_response" do
    test "redirects when data is valid", %{
      conn: conn
    } do
      SurveysMock
      |> expect(:get_survey_response!, fn id ->
        %SurveyResponse{id: id, radar_guid: @radar_guid}
      end)
      |> expect(:update_survey_response_from_survey, fn survey_response, _params ->
        {:ok, survey_response}
      end)

      conn =
        put(
          conn,
          survey_response_path(conn, :update, %SurveyResponse{id: 1}),
          survey: @update_attrs
        )

      assert redirected_to(conn) == survey_response_path(conn, :show, %SurveyResponse{id: 1})
    end

    test "renders errors when data is invalid", %{
      conn: conn
    } do
      SurveysMock
      |> expect(:get_survey_response!, fn id ->
        %SurveyResponse{id: id, radar_guid: @radar_guid}
      end)
      |> expect(:update_survey_response_from_survey, fn survey_response, params ->
        {:error, changeset(%Survey{radar_guid: survey_response.radar_guid}, params)}
      end)

      conn =
        put(
          conn,
          survey_response_path(conn, :update, %SurveyResponse{id: 1}),
          survey: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Survey response"
    end
  end
end
