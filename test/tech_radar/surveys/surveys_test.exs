defmodule TechRadar.SurveysTest do
  use TechRadar.DataCase

  alias TechRadar.Surveys

  describe "survey_answers" do
    alias TechRadar.Surveys.SurveyAnswer

    @valid_attrs %{answers: "some answers", radar_guid: "7488a646-e31f-11e4-aace-600308960662"}
    @update_attrs %{answers: "some updated answers", radar_guid: "7488a646-e31f-11e4-aace-600308960668"}
    @invalid_attrs %{answers: nil, radar_guid: nil}

    def survey_answer_fixture(attrs \\ %{}) do
      {:ok, survey_answer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Surveys.create_survey_answer()

      survey_answer
    end

    test "list_survey_answers/0 returns all survey_answers" do
      survey_answer = survey_answer_fixture()
      assert Surveys.list_survey_answers() == [survey_answer]
    end

    test "get_survey_answer!/1 returns the survey_answer with given id" do
      survey_answer = survey_answer_fixture()
      assert Surveys.get_survey_answer!(survey_answer.id) == survey_answer
    end

    test "create_survey_answer/1 with valid data creates a survey_answer" do
      assert {:ok, %SurveyAnswer{} = survey_answer} = Surveys.create_survey_answer(@valid_attrs)
      assert survey_answer.answers == "some answers"
      assert survey_answer.radar_guid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_survey_answer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Surveys.create_survey_answer(@invalid_attrs)
    end

    test "update_survey_answer/2 with valid data updates the survey_answer" do
      survey_answer = survey_answer_fixture()
      assert {:ok, survey_answer} = Surveys.update_survey_answer(survey_answer, @update_attrs)
      assert %SurveyAnswer{} = survey_answer
      assert survey_answer.answers == "some updated answers"
      assert survey_answer.radar_guid == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_survey_answer/2 with invalid data returns error changeset" do
      survey_answer = survey_answer_fixture()
      assert {:error, %Ecto.Changeset{}} = Surveys.update_survey_answer(survey_answer, @invalid_attrs)
      assert survey_answer == Surveys.get_survey_answer!(survey_answer.id)
    end

    test "delete_survey_answer/1 deletes the survey_answer" do
      survey_answer = survey_answer_fixture()
      assert {:ok, %SurveyAnswer{}} = Surveys.delete_survey_answer(survey_answer)
      assert_raise Ecto.NoResultsError, fn -> Surveys.get_survey_answer!(survey_answer.id) end
    end

    test "change_survey_answer/1 returns a survey_answer changeset" do
      survey_answer = survey_answer_fixture()
      assert %Ecto.Changeset{} = Surveys.change_survey_answer(survey_answer)
    end
  end
end
