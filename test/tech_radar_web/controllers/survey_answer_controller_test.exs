defmodule TechRadarWeb.SurveyAnswerControllerTest do
  use TechRadarWeb.ConnCase

  alias TechRadar.Surveys

  @create_attrs %{
    answers: %{"some answers" => 2},
    radar_guid: "7488a646-e31f-11e4-aace-600308960662"
  }
  @update_attrs %{
    answers: %{"some answers" => 3},
    radar_guid: "7488a646-e31f-11e4-aace-600308960668"
  }
  @invalid_attrs %{answers: nil, radar_guid: nil}

  def fixture(:survey_answer) do
    {:ok, survey_answer} = Surveys.create_survey_answer(@create_attrs)
    survey_answer
  end

  describe "create survey_answer" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, survey_answer_path(conn, :create), survey_answer: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == survey_answer_path(conn, :show, id)

      conn = get(conn, survey_answer_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Survey answer"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, survey_answer_path(conn, :create), survey_answer: @invalid_attrs)
      assert html_response(conn, 200) =~ "Oops, something went wrong!"
    end
  end

  describe "edit survey_answer" do
    setup [:create_survey_answer]

    test "renders form for editing chosen survey_answer", %{
      conn: conn,
      survey_answer: survey_answer
    } do
      conn = get(conn, survey_answer_path(conn, :edit, survey_answer))
      assert html_response(conn, 200) =~ "Edit Survey answer"
    end
  end

  describe "update survey_answer" do
    setup [:create_survey_answer]

    test "redirects when data is valid", %{conn: conn, survey_answer: survey_answer} do
      conn =
        put(conn, survey_answer_path(conn, :update, survey_answer), survey_answer: @update_attrs)

      assert redirected_to(conn) == survey_answer_path(conn, :show, survey_answer)

      conn = get(conn, survey_answer_path(conn, :show, survey_answer))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, survey_answer: survey_answer} do
      conn =
        put(conn, survey_answer_path(conn, :update, survey_answer), survey_answer: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Survey answer"
    end
  end

  defp create_survey_answer(_) do
    survey_answer = fixture(:survey_answer)
    {:ok, survey_answer: survey_answer}
  end
end
