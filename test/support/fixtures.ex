defmodule Sentimeter.Fixtures do
  @moduledoc """
  This module creates some fixtures to be used in testing.
  """
  alias Sentimeter.Surveys.Trend
  alias Sentimeter.Surveys.Survey
  alias Sentimeter.Surveys.SurveyTrend
  alias Sentimeter.Responses.Response
  alias Sentimeter.Responses.Answer
  alias Sentimeter.Repo

  @spec survey_attrs(Map.t()) :: Map.t()
  def survey_attrs(attrs \\ %{}) do
    valid_attrs = %{
      closing: "some closing",
      intro: "some intro",
      name: "some name",
      section_1_desc: "some section_1_desc",
      section_2_desc: "some section_2_desc",
      x_max_label: "some x_max_label",
      x_min_label: "some x_min_label",
      y_max_label: "some y_max_label",
      y_min_label: "some y_min_label",
      survey_trends: []
    }

    attrs |> Enum.into(valid_attrs)
  end

  @spec survey() :: %Survey{} | %Ecto.Changeset{}
  @spec survey(attrs :: Map.t()) :: %Survey{} | %Ecto.Changeset{}
  def survey(attrs \\ %{}) do
    {:ok, survey} =
      %Survey{}
      |> Survey.changeset(survey_attrs(attrs))
      |> Repo.insert()

    survey
  end

  @spec trend_attrs(Map.t()) :: Map.t()
  def trend_attrs(attrs \\ %{}) do
    valid_attrs = %{name: "some name", description: "terrible tech"}
    attrs |> Enum.into(valid_attrs)
  end

  @spec trend() :: %Trend{} | %Ecto.Changeset{}
  @spec trend(attrs :: Map.t()) :: %Trend{} | %Ecto.Changeset{}
  def trend(attrs \\ %{}) do
    {:ok, trend} =
      %Trend{}
      |> Trend.changeset(trend_attrs(attrs))
      |> Repo.insert()

    trend
  end

  @spec survey_trend() :: %SurveyTrend{} | %Ecto.Changeset{}
  @spec survey_trend(attrs :: Map.t()) :: %SurveyTrend{} | %Ecto.Changeset{}
  def survey_trend(attrs \\ %{}) do
    valid_attrs = %{}

    {:ok, survey_trend} =
      %SurveyTrend{}
      |> SurveyTrend.changeset(attrs |> Enum.into(valid_attrs))
      |> Repo.insert()

    survey_trend
  end

  @spec response_attrs(Map.t()) :: Map.t()
  def response_attrs(attrs \\ %{}) do
    valid_attrs = %{
      email: "example@example.com",
      survey_guid: "7488a646-e31f-11e4-aace-600308960662",
      answers: []
    }

    attrs |> Enum.into(valid_attrs)
  end

  @spec response() :: %Response{} | %Ecto.Changeset{}
  @spec response(attrs :: Map.t()) :: %Response{} | %Ecto.Changeset{}
  def response(attrs \\ %{}) do
    {:ok, response} =
      %Response{}
      |> Response.changeset(response_attrs(attrs))
      |> Repo.insert()

    response
  end

  @spec answer_attrs(Map.t()) :: Map.t()
  def answer_attrs(attrs \\ %{}) do
    valid_attrs = %{
      survey_trend_guid: "7488a646-e31f-11e4-aace-600308960662",
      thoughts: "some thoughts",
      would_recommend: :yes,
      x: 1,
      y: 2
    }

    attrs |> Enum.into(valid_attrs)
  end

  @spec answer() :: %Answer{} | %Ecto.Changeset{}
  @spec answer(attrs :: Map.t()) :: %Answer{} | %Ecto.Changeset{}
  def answer(attrs \\ %{}) do
    {:ok, answer} =
      %Answer{}
      |> Answer.changeset(answer_attrs(attrs))
      |> Repo.insert()

    answer
  end
end
