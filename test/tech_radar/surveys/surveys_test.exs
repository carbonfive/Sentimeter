defmodule TechRadar.SurveysTest do
  use TechRadar.DataCase
  import Mox
  alias TechRadar.Surveys.SurveysImpl, as: Surveys
  alias TechRadar.RadarsMock
  import TechRadar.Factory
  alias TechRadar.RadarsMock

  describe "surveys" do
    alias TechRadar.Surveys.SurveyResponse
    alias TechRadar.Surveys.SurveyAnswer
    @create_guid "7488a646-e31f-11e4-aace-600308960662"
    @update_guid "7488a646-e31f-11e4-aace-600308960668"
    @valid_attrs %{
      radar_guid: @create_guid,
      category_1_questions: [%{radar_trend_guid: @create_guid, answer: 1}],
      category_2_questions: [],
      category_3_questions: [],
      category_4_questions: []
    }
    @update_attrs %{
      radar_guid: @update_guid,
      category_1_questions: [%{radar_trend_guid: @update_guid, answer: 2}],
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

    setup do
      radar = insert(:radar)

      trends_by_category =
        [1, 2, 3, 4]
        |> Enum.map(fn num ->
          {num,
           [
             insert(:radar_trend, category: num, radar: radar),
             insert(:radar_trend, category: num, radar: radar)
           ]}
        end)
        |> Enum.into(%{})

      RadarsMock
      |> expect(:get_radar_by_guid!, fn _ -> radar end)
      |> expect(:get_trends_by_radar_guid, fn _ ->
        trends_by_category
        |> Enum.map(fn {num, radar_trends} ->
          {num,
           radar_trends
           |> Enum.map(fn radar_trend -> {radar_trend.guid, radar_trend.trend} end)
           |> Map.new()}
        end)
        |> Map.new()
      end)

      {:ok, radar: radar, trends_by_category: trends_by_category}
    end

    def survey_response_fixture_from_survey(attrs \\ %{}) do
      {:ok, survey_response} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Surveys.create_survey_response_from_survey()

      survey_response
    end

    test "survey_from_radar_guid!/1 returns a survey struct with radar attributes", %{
      radar: radar
    } do
      survey = Surveys.survey_from_radar_guid!(radar.guid)
      assert survey.radar_guid == radar.guid
      assert survey.category_1_name == radar.category_1_name
      assert survey.category_2_name == radar.category_2_name
      assert survey.category_3_name == radar.category_3_name
      assert survey.category_4_name == radar.category_4_name
      assert survey.innermost_level_name == radar.innermost_level_name
      assert survey.intro == radar.intro
      assert survey.level_2_name == radar.level_2_name
      assert survey.level_3_name == radar.level_3_name
      assert survey.name == radar.name
      assert survey.outermost_level_name == radar.outermost_level_name
    end

    test "survey_from_radar_guid!/1 returns a survey struct with trend categories", %{
      radar: radar,
      trends_by_category: trends_by_category
    } do
      survey = Surveys.survey_from_radar_guid!(radar.guid)

      category_1_trends = Map.get(trends_by_category, 1) |> Enum.sort_by(& &1.guid)

      Enum.zip(
        survey.category_1_questions
        |> Enum.sort_by(& &1.radar_trend_guid),
        category_1_trends
      )
      |> Enum.each(fn {survey_question, radar_trend} ->
        assert survey_question.radar_trend_guid == radar_trend.guid
        trend = Repo.one(Ecto.assoc(radar_trend, :trend))
        assert survey_question.trend.name == trend.name
        assert survey_question.trend.description == trend.description
      end)
    end

    test "survey_from_survey_response!/1 returns a survey struct with trends with answers", %{
      radar: radar,
      trends_by_category: trends_by_category
    } do
      survey_answers =
        trends_by_category
        |> Enum.flat_map(fn {_, radar_trends} ->
          radar_trends
          |> Enum.map(fn radar_trend ->
            insert(:survey_answer, radar_trend_guid: radar_trend.guid)
          end)
        end)

      survey_response =
        insert(
          :survey_response,
          radar_guid: radar.guid,
          survey_answers: survey_answers
        )

      survey = Surveys.survey_from_survey_response!(survey_response)
      assert survey.radar_guid == radar.guid

      survey_answers_by_guid =
        survey_answers
        |> Enum.map(fn survey_answer -> {survey_answer.radar_trend_guid, survey_answer.answer} end)
        |> Enum.into(%{})

      survey.category_1_questions
      |> Enum.each(fn survey_question ->
        survey_answer = Map.get(survey_answers_by_guid, survey_question.radar_trend_guid)
        assert survey_answer == survey_question.answer
      end)
    end

    test "create_survey_response_from_survey/1 with valid data creates a survey response" do
      assert {:ok, %SurveyResponse{} = survey_response} =
               Surveys.create_survey_response_from_survey(@valid_attrs)

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

    test "create_survey_response_from_survey/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Surveys.create_survey_response_from_survey(@invalid_attrs)
    end

    test "update_survey_response_from_survey/2 with valid data updates the survey_response" do
      survey_response = survey_response_fixture_from_survey()

      assert {:ok, survey_response} =
               Surveys.update_survey_response_from_survey(survey_response, @update_attrs)

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

    test "update_survey_response_from_survey/2 with invalid data returns error changeset" do
      survey_response = survey_response_fixture_from_survey()

      assert {:error, %Ecto.Changeset{}} =
               Surveys.update_survey_response_from_survey(survey_response, @invalid_attrs)

      assert survey_response == Surveys.get_survey_response!(survey_response.id)
    end
  end

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
