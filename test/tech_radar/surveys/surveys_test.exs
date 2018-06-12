defmodule TechRadar.SurveysTest do
  use TechRadar.DataCase
  import Mox
  alias TechRadar.Surveys
  alias TechRadar.RadarsMock

  describe "survey_responses" do
    alias TechRadar.Surveys.SurveyResponse
    alias TechRadar.Surveys.SurveyAnswer
    @create_guid "7488a646-e31f-11e4-aace-600308960662"
    @update_guid "7488a646-e31f-11e4-aace-600308960668"
    @valid_attrs %{
      radar_guid: @create_guid,
      survey_answers: [%{radar_trend_guid: @create_guid, answer: 1}]
    }
    @update_attrs %{
      radar_guid: @update_guid,
      survey_answers: [%{radar_trend_guid: @update_guid, answer: 2}]
    }
    @invalid_attrs %{radar_guid: nil, survey_answers: []}

    def survey_response_fixture(attrs \\ %{}) do
      {:ok, survey_response} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Surveys.create_survey_response()

      survey_response
    end

    test "get_survey_response!/1 returns the survey_response with given id" do
      survey_response = survey_response_fixture()
      assert Surveys.get_survey_response!(survey_response.id) == survey_response
    end

    test "create_survey_response/1 with valid data creates a survey_response" do
      assert {:ok, %SurveyResponse{} = survey_response} =
               Surveys.create_survey_response(@valid_attrs)

      assert survey_response.radar_guid == @create_guid

      survey_answer =
        Repo.one(
          from(
            sa in SurveyAnswer,
            join: sr in assoc(sa, :survey_response),
            where: sr.id == ^survey_response.id
          )
        )

      assert survey_answer.radar_trend_guid == @create_guid
      assert survey_answer.answer == 1
    end

    test "create_survey_response/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Surveys.create_survey_response(@invalid_attrs)
    end

    test "update_survey_response/2 with valid data updates the survey_response" do
      survey_response = survey_response_fixture()

      assert {:ok, survey_response} =
               Surveys.update_survey_response(survey_response, @update_attrs)

      assert %SurveyResponse{} = survey_response
      assert survey_response.radar_guid == @update_guid

      survey_answer =
        Repo.one(
          from(
            sa in SurveyAnswer,
            join: sr in assoc(sa, :survey_response),
            where: sr.id == ^survey_response.id
          )
        )

      assert survey_answer.radar_trend_guid == @update_guid
      assert survey_answer.answer == 2
    end

    test "update_survey_response/2 with invalid data returns error changeset" do
      survey_response = survey_response_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Surveys.update_survey_response(survey_response, @invalid_attrs)

      assert survey_response == Surveys.get_survey_response!(survey_response.id)
    end

    test "delete_survey_response/1 deletes the survey_response" do
      survey_response = survey_response_fixture()
      assert {:ok, %SurveyResponse{}} = Surveys.delete_survey_response(survey_response)
      assert_raise Ecto.NoResultsError, fn -> Surveys.get_survey_response!(survey_response.id) end
    end

    test "change_survey_response/1 returns a survey_response changeset" do
      survey_response = survey_response_fixture()
      assert %Ecto.Changeset{} = Surveys.change_survey_response(survey_response)
    end
  end
end
