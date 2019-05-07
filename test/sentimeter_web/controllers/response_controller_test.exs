defmodule SentimeterWeb.ResponseControllerTest do
  use SentimeterWeb.ConnCase
  import Mox
  alias Sentimeter.ResponsesMock
  alias Sentimeter.SurveysMock
  alias Sentimeter.Responses.Response
  alias Sentimeter.Surveys.Survey
  alias Sentimeter.Responses.TrendChoiceForm

  @create_attrs %{emails: "  bob@example.com \n jill@example.com "}
  @update_attrs %{}
  @invalid_attrs %{}
  @guid "7488a646-e31f-11e4-aace-600308960662"

  def changeset(%Response{} = response, attrs \\ %{}) do
    Ecto.Changeset.change(response, attrs)
  end

  setup do
    ResponsesMock |> stub(:change_response, fn response -> changeset(response) end)
    :ok
  end

  setup :verify_on_exit!

  describe "index" do
    test "lists all responses for survey", %{conn: conn} do
      guid = "7488a646-e31f-11e4-aace-600308960662"

      SurveysMock
      |> expect(:get_survey!, fn id ->
        %Survey{id: id, guid: "7488a646-e31f-11e4-aace-600308960662"}
      end)

      ResponsesMock
      |> expect(:responses_for_survey_guid, fn matched_guid ->
        assert matched_guid == guid
        []
      end)

      conn = get(conn, Routes.survey_response_path(conn, :index, %Survey{id: 1}))
      assert html_response(conn, 200) =~ "Listing Responses"
    end
  end

  describe "create responses" do
    test "redirects to show when data is valid", %{conn: conn} do
      guid = "7488a646-e31f-11e4-aace-600308960662"

      SurveysMock
      |> expect(:get_survey!, fn id ->
        %Survey{id: id, guid: "7488a646-e31f-11e4-aace-600308960662"}
      end)

      ResponsesMock
      |> expect(:create_responses, fn emails, guid ->
        assert emails == ["bob@example.com", "jill@example.com"]
        assert guid == guid
        {:ok, [%Response{id: 1}]}
      end)

      conn =
        post(conn, Routes.survey_response_path(conn, :create, %Survey{id: 1}),
          response: @create_attrs
        )

      assert redirected_to(conn) == Routes.survey_response_path(conn, :index, %Survey{id: 1})
    end

    test "renders errors when data is invalid", %{conn: conn} do
      guid = "7488a646-e31f-11e4-aace-600308960662"

      SurveysMock
      |> expect(:get_survey!, fn id ->
        %Survey{id: id, guid: "7488a646-e31f-11e4-aace-600308960662"}
      end)

      ResponsesMock
      |> expect(:create_responses, fn emails, guid ->
        assert guid == guid
        {:error, changeset(%Response{}) |> Ecto.Changeset.add_error(:email, "invalid")}
      end)
      |> expect(:responses_for_survey_guid, fn matched_guid ->
        assert matched_guid == guid
        []
      end)

      conn =
        post(conn, Routes.survey_response_path(conn, :create, %Survey{id: 1}),
          response: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Listing Responses"
    end
  end

  describe "edit response" do
    test "renders form for editing chosen response", %{conn: conn} do
      ResponsesMock
      |> expect(:get_response_by_guid!, fn guid -> %Response{guid: guid, survey_guid: @guid} end)
      |> expect(:trend_choice_form, fn _ -> %TrendChoiceForm{} end)
      |> expect(:change_trend_choice_form, fn tcf -> TrendChoiceForm.changeset(tcf, %{}) end)

      SurveysMock
      |> expect(:get_survey_by_guid!, fn guid -> %Survey{id: 1, guid: guid, intro: ""} end)

      conn = get(conn, Routes.response_path(conn, :edit, @guid))
      assert html_response(conn, 200)
    end
  end

  describe "delete response" do
    test "deletes chosen response", %{conn: conn} do
      ResponsesMock
      |> expect(:delete_response, fn response -> {:ok, response} end)
      |> expect(:get_response_by_guid!, fn guid -> %Response{guid: guid, survey_guid: @guid} end)

      SurveysMock
      |> expect(:get_survey_by_guid!, fn guid -> %Survey{id: 1, guid: guid} end)

      conn = delete(conn, Routes.response_path(conn, :delete, @guid))

      assert redirected_to(conn) ==
               Routes.survey_response_path(conn, :index, %Survey{id: 1})
    end
  end
end
