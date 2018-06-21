defmodule TechRadar.Surveys do
  @moduledoc """
  The Surveys context.
  """

  alias TechRadar.Surveys.SurveyResponse
  alias TechRadar.Surveys.Survey

  @doc """
  Build a survey schema from a radar GUID

  Raises `Ecto.NoResultsError` if the radar does not exist

  ## Examples

      iex> survey_from_radar_guid!("ABS-123")
      %Survey{}

      iex> survey_from_radar_guid!("FFBS-123")
      ** (Ecto.NoResultsError)
  """

  @callback survey_from_radar_guid!(
              guid :: Ecto.UUID.type(),
              answers :: %{optional(Ecto.UUID) => number},
              id :: integer() | nil
            ) :: %Survey{} | no_return
  @callback survey_from_radar_guid!(
              guid :: Ecto.UUID.type(),
              answers :: %{optional(Ecto.UUID) => number}
            ) :: %Survey{} | no_return
  @callback survey_from_radar_guid!(guid :: Ecto.UUID.type()) :: %Survey{} | no_return
  @doc """
  Build a survey schema from an existing response, pre-filling existing answers

  Raises `Ecto.NoResultsError` if the radar does not exist

  ## Examples

      iex> survey_from_survey_response!(survey_response)
      %Survey{}

      iex> survey_from_survey_response!(survey_response)
      ** (Ecto.NoResultsError)
  """

  @callback survey_from_survey_response!(survey_response :: %SurveyResponse{}) ::
              %Survey{} | no_return

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking survey changes.

  ## Examples

      iex> change_survey(survey)
      %Ecto.Changeset{source: %Survey{}}

  """
  @callback change_survey(survey :: %Survey{}) :: %Ecto.Changeset{}

  @doc """
  Creates a survey_response, but using attributes for a survey

  ## Examples

      iex> create_survey_response(%{field: value})
      {:ok, %SurveyResponse{}}

      iex> create_survey_response(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @callback create_survey_response_from_survey(attrs :: Map.t()) ::
              {:ok, %SurveyResponse{}} | {:error, %Ecto.Changeset{}}

  @doc """
  Updates a survey_response, but using attributes for a survey

  ## Examples

      iex> update_survey_response(survey_response, %{field: new_value})
      {:ok, %SurveyResponse{}}

      iex> update_survey_response(survey_response, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @callback update_survey_response_from_survey(
              survey_response :: %SurveyResponse{},
              attrs :: Map.t()
            ) :: {:ok, %SurveyResponse{}} | {:error, %Ecto.Changeset{}}

  @doc """
  Gets a single survey_response.

  Raises `Ecto.NoResultsError` if the Survey response does not exist.

  ## Examples

      iex> get_survey_response!(123)
      %SurveyResponse{}

      iex> get_survey_response!(456)
      ** (Ecto.NoResultsError)

  """
  @callback get_survey_response!(id :: number) :: %SurveyResponse{} | no_return

  @doc """
  Creates a survey_response.

  ## Examples

      iex> create_survey_response(%{field: value})
      {:ok, %SurveyResponse{}}

      iex> create_survey_response(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @callback create_survey_response() :: {:ok, %SurveyResponse{}} | {:error, %Ecto.Changeset{}}
  @callback create_survey_response(attrs :: Map.t()) ::
              {:ok, %SurveyResponse{}} | {:error, %Ecto.Changeset{}}

  @doc """
  Updates a survey_response.

  ## Examples

      iex> update_survey_response(survey_response, %{field: new_value})
      {:ok, %SurveyResponse{}}

      iex> update_survey_response(survey_response, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @callback update_survey_response(survey_response :: %SurveyResponse{}, attrs :: Map.t()) ::
              {:ok, %SurveyResponse{}} | {:error, %Ecto.Changeset{}}

  @doc """
  Deletes a SurveyResponse.

  ## Examples

      iex> delete_survey_response(survey_response)
      {:ok, %SurveyResponse{}}

      iex> delete_survey_response(survey_response)
      {:error, %Ecto.Changeset{}}

  """
  @callback delete_survey_response(survey_response :: %SurveyResponse{}) ::
              {:ok, %SurveyResponse{}} | {:error, %Ecto.Changeset{}}

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking survey_response changes.

  ## Examples

      iex> change_survey_response(survey_response)
      %Ecto.Changeset{source: %SurveyResponse{}}

  """
  @callback change_survey_response(survey_response :: %SurveyResponse{}) :: %Ecto.Changeset{}

  @doc """
  Gets all survey responses for a radar quid

  ## Examples

      iex> get_survey_responses_for_radar_guid("abc-123")
      [%SurveyResponse{}]
  """
  @callback get_survey_responses_for_radar_guid(guid :: Ecto.UUID) :: [%SurveyResponse{}]
end
