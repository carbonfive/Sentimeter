defmodule Sentimeter.Surveys do
  @moduledoc """
  The Surveys context.
  """

  alias Sentimeter.Surveys.Trend

  @doc """
  Returns the list of trends.

  ## Examples

      iex> list_trends()
      [%Trend{}, ...]

  """
  @callback list_trends() :: [%Trend{}]

  @doc """
  Gets a single trend.

  Raises `Ecto.NoResultsError` if the Trend does not exist.

  ## Examples

      iex> get_trend!(123)
      %Trend{}

      iex> get_trend!(456)
      ** (Ecto.NoResultsError)

  """
  @callback get_trend!(id :: number) :: %Trend{} | no_return

  @doc """
  Creates a trend.

  ## Examples

      iex> create_trend(%{field: value})
      {:ok, %Trend{}}

      iex> create_trend(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @callback create_trend() :: {:ok, %Trend{}} | {:error, %Ecto.Changeset{}}
  @callback create_trend(attrs :: Map.t()) :: {:ok, %Trend{}} | {:error, %Ecto.Changeset{}}

  @doc """
  Updates a trend.

  ## Examples

      iex> update_trend(trend, %{field: new_value})
      {:ok, %Trend{}}

      iex> update_trend(trend, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @callback update_trend(trend :: %Trend{}, attrs :: Map.t()) ::
              {:ok, %Trend{}} | {:error, %Ecto.Changeset{}}

  @doc """
  Deletes a Trend.

  ## Examples

      iex> delete_trend(trend)
      {:ok, %Trend{}}

      iex> delete_trend(trend)
      {:error, %Ecto.Changeset{}}

  """
  @callback delete_trend(trend :: %Trend{}) :: {:ok, %Trend{}} | {:error, %Ecto.Changeset{}}

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking trend changes.

  ## Examples

      iex> change_trend(trend)
      %Ecto.Changeset{source: %Trend{}}

  """
  @callback change_trend(trend :: %Trend{}) :: %Ecto.Changeset{}

  alias Sentimeter.Surveys.Survey

  @doc """
  Returns the list of surveys.

  ## Examples

      iex> list_surveys()
      [%Survey{}, ...]

  """
  @callback list_surveys() :: [%Survey{}]

  @doc """
  Gets a single survey.

  Raises `Ecto.NoResultsError` if the Survey does not exist.

  ## Examples

      iex> get_survey!(123)
      %Survey{}

      iex> get_survey!(456)
      ** (Ecto.NoResultsError)

  """
  @callback get_survey!(id :: number) :: %Survey{} | no_return

  # @doc """
  # Gets a single survey by GUID.

  # Raises `Ecto.NoResultsError` if the Survey does not exist.

  # ## Examples

  #     iex> get_survey_by_guid!("ADBCD-123")
  #     %Survey{}

  #     iex> get_survey_by_guid!("ADDJE-123")
  #     ** (Ecto.NoResultsError)

  # """
  # @callback get_survey_by_guid!(guid :: Ecto.UUID.type()) :: %Survey{} | no_return

  # @doc """
  # Gets all trends for a survey with given GUID, grouped by category

  # ## Examples

  #     iex> get_trends_by_survey_guid("ADBCD-123")
  #     %{
  #       1: [%Trend{}]
  #     %}

  # """
  # @callback get_trends_by_survey_guid(guid :: Ecto.UUID.type()) :: %{
  #             required(number) => %{required(Ecto.UUID) => %Trend{}}
  #           }

  # @doc """
  # Determine if the given survey trend guids cover the complete set of survey trends for the given survey guid

  # ## Examples

  #     iex> survey_trend_guids_match_survey_guid("ADBCD-123", ["CCDD-123", "JJJDDD-456"])
  #     true

  # """
  # @callback survey_trend_guids_match_survey_guid(
  #             guid :: Ecto.UUID.type(),
  #             survey_trend_guids :: [Ecto.UUID.type()]
  #           ) :: true | false

  @doc """
  Creates a survey.

  ## Examples

      iex> create_survey(%{field: value})
      {:ok, %Survey{}}

      iex> create_survey(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @callback create_survey() :: {:ok, %Survey{}} | {:error, %Ecto.Changeset{}}
  @callback create_survey(attrs :: Map.t()) :: {:ok, %Survey{}} | {:error, %Ecto.Changeset{}}

  @doc """
  Updates a survey.

  ## Examples

      iex> update_survey(survey, %{field: new_value})
      {:ok, %Survey{}}

      iex> update_survey(survey, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @callback update_survey(survey :: %Survey{}, attrs :: Map.t()) ::
              {:ok, %Survey{}} | {:error, %Ecto.Changeset{}}

  @doc """
  Deletes a Survey.

  ## Examples

      iex> delete_survey(survey)
      {:ok, %Survey{}}

      iex> delete_survey(survey)
      {:error, %Ecto.Changeset{}}

  """
  @callback delete_survey(survey :: %Survey{}) :: {:ok, %Survey{}} | {:error, %Ecto.Changeset{}}

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking survey changes.

  ## Examples

      iex> change_survey(survey)
      %Ecto.Changeset{source: %Survey{}}

  """
  @callback change_survey(survey :: %Survey{}) :: %Ecto.Changeset{}
end
