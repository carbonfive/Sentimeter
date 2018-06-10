defmodule TechRadar.Surveys do
  @moduledoc """
  The Surveys context.
  """

  import Ecto.Query, warn: false
  alias TechRadar.Repo

  alias TechRadar.Surveys.SurveyAnswer

  @doc """
  Returns the list of survey_answers.

  ## Examples

      iex> list_survey_answers()
      [%SurveyAnswer{}, ...]

  """
  def list_survey_answers do
    Repo.all(SurveyAnswer)
  end

  @doc """
  Gets a single survey_answer.

  Raises `Ecto.NoResultsError` if the Survey answer does not exist.

  ## Examples

      iex> get_survey_answer!(123)
      %SurveyAnswer{}

      iex> get_survey_answer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_survey_answer!(id), do: Repo.get!(SurveyAnswer, id)

  @doc """
  Creates a survey_answer.

  ## Examples

      iex> create_survey_answer(%{field: value})
      {:ok, %SurveyAnswer{}}

      iex> create_survey_answer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_survey_answer(attrs \\ %{}) do
    %SurveyAnswer{}
    |> SurveyAnswer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a survey_answer.

  ## Examples

      iex> update_survey_answer(survey_answer, %{field: new_value})
      {:ok, %SurveyAnswer{}}

      iex> update_survey_answer(survey_answer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_survey_answer(%SurveyAnswer{} = survey_answer, attrs) do
    survey_answer
    |> SurveyAnswer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a SurveyAnswer.

  ## Examples

      iex> delete_survey_answer(survey_answer)
      {:ok, %SurveyAnswer{}}

      iex> delete_survey_answer(survey_answer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_survey_answer(%SurveyAnswer{} = survey_answer) do
    Repo.delete(survey_answer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking survey_answer changes.

  ## Examples

      iex> change_survey_answer(survey_answer)
      %Ecto.Changeset{source: %SurveyAnswer{}}

  """
  def change_survey_answer(%SurveyAnswer{} = survey_answer) do
    SurveyAnswer.changeset(survey_answer, %{})
  end
end
