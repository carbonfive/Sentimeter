defmodule Sentimeter.SurveysTest do
  use Sentimeter.DataCase

  alias Sentimeter.Surveys.SurveysImpl, as: Surveys

  describe "trends" do
    alias Sentimeter.Surveys.Trend

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    def trend_fixture(attrs \\ %{}) do
      {:ok, trend} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Surveys.create_trend()

      trend
    end

    test "list_trends/0 returns all trends" do
      trend = trend_fixture()
      assert Surveys.list_trends() == [trend]
    end

    test "get_trend!/1 returns the trend with given id" do
      trend = trend_fixture()
      assert Surveys.get_trend!(trend.id) == trend
    end

    test "create_trend/1 with valid data creates a trend" do
      assert {:ok, %Trend{} = trend} = Surveys.create_trend(@valid_attrs)
      assert trend.description == "some description"
      assert trend.name == "some name"
    end

    test "create_trend/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Surveys.create_trend(@invalid_attrs)
    end

    test "update_trend/2 with valid data updates the trend" do
      trend = trend_fixture()
      assert {:ok, trend} = Surveys.update_trend(trend, @update_attrs)
      assert %Trend{} = trend
      assert trend.description == "some updated description"
      assert trend.name == "some updated name"
    end

    test "update_trend/2 with invalid data returns error changeset" do
      trend = trend_fixture()
      assert {:error, %Ecto.Changeset{}} = Surveys.update_trend(trend, @invalid_attrs)
      assert trend == Surveys.get_trend!(trend.id)
    end

    test "delete_trend/1 deletes the trend" do
      trend = trend_fixture()
      assert {:ok, %Trend{}} = Surveys.delete_trend(trend)
      assert_raise Ecto.NoResultsError, fn -> Surveys.get_trend!(trend.id) end
    end

    test "change_trend/1 returns a trend changeset" do
      trend = trend_fixture()
      assert %Ecto.Changeset{} = Surveys.change_trend(trend)
    end
  end

  describe "surveys" do
    alias Sentimeter.Surveys.Survey

    @valid_attrs %{
      closing: "some closing",
      intro: "some intro",
      name: "some name",
      section_1_desc: "some section_1_desc",
      section_2_desc: "some section_2_desc",
      x_max_label: "some x_max_label",
      x_min_label: "some x_min_label",
      y_max_label: "some y_max_label",
      y_min_label: "some y_min_label"
    }
    @update_attrs %{
      closing: "some updated closing",
      intro: "some updated intro",
      name: "some updated name",
      section_1_desc: "some updated section_1_desc",
      section_2_desc: "some updated section_2_desc",
      x_max_label: "some updated x_max_label",
      x_min_label: "some updated x_min_label",
      y_max_label: "some updated y_max_label",
      y_min_label: "some updated y_min_label"
    }
    @invalid_attrs %{
      closing: nil,
      intro: nil,
      name: nil,
      section_1_desc: nil,
      section_2_desc: nil,
      x_max_label: nil,
      x_min_label: nil,
      y_max_label: nil,
      y_min_label: nil
    }

    def survey_fixture(attrs \\ %{}) do
      {:ok, survey} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Surveys.create_survey()

      survey
    end

    test "list_surveys/0 returns all surveys" do
      survey = survey_fixture()
      assert Surveys.list_surveys() == [survey]
    end

    test "get_survey!/1 returns the survey with given id" do
      survey = survey_fixture()
      assert Surveys.get_survey!(survey.id) == survey
    end

    test "create_survey/1 with valid data creates a survey" do
      assert {:ok, %Survey{} = survey} = Surveys.create_survey(@valid_attrs)
      assert survey.closing == "some closing"
      assert survey.intro == "some intro"
      assert survey.name == "some name"
      assert survey.section_1_desc == "some section_1_desc"
      assert survey.section_2_desc == "some section_2_desc"
      assert survey.x_max_label == "some x_max_label"
      assert survey.x_min_label == "some x_min_label"
      assert survey.y_max_label == "some y_max_label"
      assert survey.y_min_label == "some y_min_label"
    end

    test "create_survey/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Surveys.create_survey(@invalid_attrs)
    end

    test "update_survey/2 with valid data updates the survey" do
      survey = survey_fixture()
      assert {:ok, %Survey{} = survey} = Surveys.update_survey(survey, @update_attrs)
      assert survey.closing == "some updated closing"
      assert survey.intro == "some updated intro"
      assert survey.name == "some updated name"
      assert survey.section_1_desc == "some updated section_1_desc"
      assert survey.section_2_desc == "some updated section_2_desc"
      assert survey.x_max_label == "some updated x_max_label"
      assert survey.x_min_label == "some updated x_min_label"
      assert survey.y_max_label == "some updated y_max_label"
      assert survey.y_min_label == "some updated y_min_label"
    end

    test "update_survey/2 with invalid data returns error changeset" do
      survey = survey_fixture()
      assert {:error, %Ecto.Changeset{}} = Surveys.update_survey(survey, @invalid_attrs)
      assert survey == Surveys.get_survey!(survey.id)
    end

    test "delete_survey/1 deletes the survey" do
      survey = survey_fixture()
      assert {:ok, %Survey{}} = Surveys.delete_survey(survey)
      assert_raise Ecto.NoResultsError, fn -> Surveys.get_survey!(survey.id) end
    end

    test "change_survey/1 returns a survey changeset" do
      survey = survey_fixture()
      assert %Ecto.Changeset{} = Surveys.change_survey(survey)
    end
  end
end
