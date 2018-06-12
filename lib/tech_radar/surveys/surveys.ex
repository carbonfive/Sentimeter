defmodule TechRadar.Surveys do
  @moduledoc """
  The Surveys context.
  """

  import Ecto.Query, warn: false
  alias TechRadar.Repo

  alias TechRadar.Surveys.SurveyResponse

  @doc """
  Gets a single survey_response.

  Raises `Ecto.NoResultsError` if the Survey response does not exist.

  ## Examples

      iex> get_survey_response!(123)
      %SurveyResponse{}

      iex> get_survey_response!(456)
      ** (Ecto.NoResultsError)

  """
  def get_survey_response!(id), do: Repo.get!(SurveyResponse, id)

  @doc """
  Creates a survey_response.

  ## Examples

      iex> create_survey_response(%{field: value})
      {:ok, %SurveyResponse{}}

      iex> create_survey_response(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_survey_response(attrs \\ %{}) do
    %SurveyResponse{}
    |> SurveyResponse.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a survey_response.

  ## Examples

      iex> update_survey_response(survey_response, %{field: new_value})
      {:ok, %SurveyResponse{}}

      iex> update_survey_response(survey_response, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_survey_response(%SurveyResponse{} = survey_response, attrs) do
    survey_response
    |> SurveyResponse.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a SurveyResponse.

  ## Examples

      iex> delete_survey_response(survey_response)
      {:ok, %SurveyResponse{}}

      iex> delete_survey_response(survey_response)
      {:error, %Ecto.Changeset{}}

  """
  def delete_survey_response(%SurveyResponse{} = survey_response) do
    Repo.delete(survey_response)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking survey_response changes.

  ## Examples

      iex> change_survey_response(survey_response)
      %Ecto.Changeset{source: %SurveyResponse{}}

  """
  def change_survey_response(%SurveyResponse{} = survey_response) do
    SurveyResponse.changeset(survey_response, %{})
  end
end
