defmodule Sentimeter.Fixtures do
  @moduledoc """
  This module creates some fixtures to be used in testing.
  """
  alias Sentimeter.Surveys.Trend
  alias Sentimeter.Surveys.Survey
  alias Sentimeter.Surveys.SurveyTrend
  alias Sentimeter.Responses.Response
  alias Sentimeter.Repo

  @spec survey() :: %Survey{} | %Ecto.Changeset{}
  @spec survey(attrs :: Map.t()) :: %Survey{} | %Ecto.Changeset{}
  def survey(attrs \\ %{}) do
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

    {:ok, survey} =
      %Survey{}
      |> Survey.changeset(
        attrs
        |> Enum.into(valid_attrs)
      )
      |> Repo.insert()

    survey
  end

  @spec trend() :: %Trend{} | %Ecto.Changeset{}
  @spec trend(attrs :: Map.t()) :: %Trend{} | %Ecto.Changeset{}
  def trend(attrs \\ %{}) do
    valid_attrs = %{name: "some name", description: "terrible tech"}

    {:ok, trend} =
      %Trend{}
      |> Trend.changeset(attrs |> Enum.into(valid_attrs))
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

  def response(attrs \\ %{}) do
    valid_attrs = %{
      email: "example@example.com",
      survey_guid: "7488a646-e31f-11e4-aace-600308960662"
    }

    {:ok, response} =
      %Response{}
      |> Response.changeset(attrs |> Enum.into(valid_attrs))
      |> Repo.insert()

    response
  end
end
