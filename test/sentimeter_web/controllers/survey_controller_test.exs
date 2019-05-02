defmodule SentimeterWeb.SurveyControllerTest do
  use SentimeterWeb.ConnCase
  import Mox
  alias Sentimeter.SurveysMock
  alias Sentimeter.Surveys.Survey

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def changeset(%Survey{} = survey, attrs \\ %{}) do
    Ecto.Changeset.change(survey, attrs)
  end

  setup do
    SurveysMock |> stub(:change_survey, fn survey -> changeset(survey) end)
    SurveysMock |> stub(:list_trends, fn -> [] end)
    :ok
  end

  setup :verify_on_exit!

  describe "index" do
    test "lists all surveys", %{conn: conn} do
      SurveysMock |> expect(:list_surveys, fn -> [] end)
      conn = get(conn, Routes.survey_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Surveys"
    end
  end

  describe "new survey" do
    test "renders form", %{conn: conn} do
      SurveysMock |> expect(:change_survey, 1, fn survey -> changeset(survey) end)
      conn = get(conn, Routes.survey_path(conn, :new))
      assert html_response(conn, 200) =~ "New Survey"
    end
  end

  describe "create survey" do
    test "redirects to show when data is valid", %{conn: conn} do
      SurveysMock |> expect(:create_survey, fn _ -> {:ok, %Survey{id: 1}} end)
      conn = post(conn, Routes.survey_path(conn, :create), survey: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.survey_path(conn, :show, id)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      SurveysMock
      |> expect(:create_survey, fn _ ->
        {:error, changeset(%Survey{})}
      end)

      conn = post(conn, Routes.survey_path(conn, :create), survey: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Survey"
    end
  end

  describe "edit survey" do
    test "renders form for editing chosen survey", %{conn: conn} do
      SurveysMock
      |> expect(:change_survey, fn survey -> changeset(survey) end)
      |> expect(:get_survey!, fn id -> %Survey{id: id} end)

      conn = get(conn, Routes.survey_path(conn, :edit, %Survey{id: 1}))
      assert html_response(conn, 200) =~ "Edit Survey"
    end
  end

  describe "update survey" do
    test "redirects when data is valid", %{conn: conn} do
      SurveysMock
      |> expect(:update_survey, fn survey, _params -> {:ok, survey} end)
      |> expect(:get_survey!, fn id -> %Survey{id: id} end)

      conn = put(conn, Routes.survey_path(conn, :update, %Survey{id: 1}), survey: @update_attrs)
      assert redirected_to(conn) == Routes.survey_path(conn, :show, %Survey{id: 1})
    end

    test "renders errors when data is invalid", %{conn: conn} do
      SurveysMock
      |> expect(:update_survey, fn survey, params -> {:error, changeset(survey, params)} end)
      |> expect(:get_survey!, fn id -> %Survey{id: id} end)

      conn = put(conn, Routes.survey_path(conn, :update, %Survey{id: 1}), survey: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Survey"
    end
  end

  describe "delete survey" do
    test "deletes chosen survey", %{conn: conn} do
      SurveysMock
      |> expect(:delete_survey, fn survey -> {:ok, survey} end)
      |> expect(:get_survey!, fn id -> %Survey{id: id} end)

      conn = delete(conn, Routes.survey_path(conn, :delete, %Survey{id: 1}))
      assert redirected_to(conn) == Routes.survey_path(conn, :index)
    end
  end
end
