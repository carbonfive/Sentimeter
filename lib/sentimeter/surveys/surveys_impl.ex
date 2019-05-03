defmodule Sentimeter.Surveys.SurveysImpl do
  @behaviour Sentimeter.Surveys

  @moduledoc """
  The Surveys context.
  """

  import Ecto.Query, warn: false
  alias Sentimeter.Repo
  alias Sentimeter.Surveys.Trend
  alias Sentimeter.Surveys.SurveyTrend

  @doc """
  Returns the list of trends.

  ## Examples

      iex> list_trends()
      [%Trend{}, ...]

  """
  def list_trends do
    Repo.all(Trend)
  end

  @doc """
  Gets a single trend.

  Raises `Ecto.NoResultsError` if the Trend does not exist.

  ## Examples

      iex> get_trend!(123)
      %Trend{}

      iex> get_trend!(456)
      ** (Ecto.NoResultsError)

  """
  def get_trend!(id), do: Repo.get!(Trend, id)

  @doc """
  Creates a trend.

  ## Examples

      iex> create_trend(%{field: value})
      {:ok, %Trend{}}

      iex> create_trend(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_trend(attrs \\ %{}) do
    %Trend{}
    |> Trend.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a trend.

  ## Examples

      iex> update_trend(trend, %{field: new_value})
      {:ok, %Trend{}}

      iex> update_trend(trend, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_trend(%Trend{} = trend, attrs) do
    trend
    |> Trend.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Trend.

  ## Examples

      iex> delete_trend(trend)
      {:ok, %Trend{}}

      iex> delete_trend(trend)
      {:error, %Ecto.Changeset{}}

  """
  def delete_trend(%Trend{} = trend) do
    Repo.delete(trend)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking trend changes.

  ## Examples

      iex> change_trend(trend)
      %Ecto.Changeset{source: %Trend{}}

  """
  def change_trend(%Trend{} = trend) do
    Trend.changeset(trend, %{})
  end

  alias Sentimeter.Surveys.Survey

  @doc """
  Returns the list of surveys.

  ## Examples

      iex> list_surveys()
      [%Survey{}, ...]

  """
  def list_surveys do
    Repo.all(Survey)
    |> Repo.preload(:survey_trends)
  end

  @doc """
  Gets a single survey.

  Raises `Ecto.NoResultsError` if the Survey does not exist.

  ## Examples

      iex> get_survey!(123)
      %Survey{}

      iex> get_survey!(456)
      ** (Ecto.NoResultsError)

  """
  def get_survey!(id) do
    Repo.get!(Survey, id)
    |> Repo.preload(:survey_trends)
  end

  @doc """
  Gets a single survey by GUID.

  Raises `Ecto.NoResultsError` if the Survey does not exist.

  ## Examples

      iex> get_survey_by_guid!("ADBCD-123")
      %Survey{}

      iex> get_survey_by_guid!("ADDJE-123")
      ** (Ecto.NoResultsError)

  """
  def get_survey_by_guid!(guid) do
    Repo.get_by!(Survey, guid: guid)
  end

  @doc """
  Gets all trends for a survey with given GUID, grouped by category

  ## Examples

      iex> get_trends_by_survey_guid("ADBCD-123")
      %{
        1: [%Trend{}]
      %}

  """
  def get_trends_by_survey_guid(guid) do
    query =
      from(
        trend in Trend,
        join: survey_trend in assoc(trend, :survey_trends),
        join: survey in assoc(survey_trend, :survey),
        where: survey.guid == ^guid,
        select: {survey_trend.guid, trend}
      )

    Repo.all(query) |> Map.new()
  end

  @doc """
  Determine if the given survey trend guids cover the complete set of survey trends for the given survey guid

  ## Examples

      iex> survey_trend_guids_match_survey_guid("ADBCD-123", ["CCDD-123", "JJJDDD-456"])
      true
  """

  def survey_trend_guids_match_survey_guid(guid, survey_trend_guids) do
    expected_guids =
      Repo.all(
        from(
          survey_trend in SurveyTrend,
          join: survey in assoc(survey_trend, :survey),
          where: survey.guid == ^guid
        )
      )
      |> Enum.map(& &1.guid)
      |> Enum.sort()

    survey_trend_guids |> Enum.sort() == expected_guids
  end

  @doc """
  Creates a survey.

  ## Examples

      iex> create_survey(%{field: value})
      {:ok, %Survey{}}

      iex> create_survey(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_survey(attrs \\ %{}) do
    %Survey{}
    |> Survey.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a survey.

  ## Examples

      iex> update_survey(survey, %{field: new_value})
      {:ok, %Survey{}}

      iex> update_survey(survey, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_survey(%Survey{} = survey, attrs) do
    survey
    |> Survey.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Survey.

  ## Examples

      iex> delete_survey(survey)
      {:ok, %Survey{}}

      iex> delete_survey(survey)
      {:error, %Ecto.Changeset{}}

  """
  def delete_survey(%Survey{} = survey) do
    Repo.delete(survey)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking survey changes.

  ## Examples

      iex> change_survey(survey)
      %Ecto.Changeset{source: %Survey{}}

  """
  def change_survey(%Survey{} = survey) do
    Survey.changeset(survey, %{})
  end
end
