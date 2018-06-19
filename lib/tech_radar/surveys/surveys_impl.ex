defmodule TechRadar.Surveys.SurveysImpl do
  @behavior TechRadar.Surveys
  @moduledoc """
  The Surveys context.
  """

  import Ecto.Query, warn: false
  alias TechRadar.Repo

  alias TechRadar.Surveys.SurveyResponse
  alias TechRadar.Surveys.Survey
  alias TechRadar.Surveys.SurveyQuestion

  @default_answer 3
  @radars Application.get_env(:tech_radar, :radars)

  @doc """
  Build a survey schema from a radar GUID

  Raises `Ecto.NoResultsError` if the radar does not exist

  ## Examples

      iex> survey_from_radar_guid!("ABS-123")
      %Survey{}

      iex> survey_from_radar_guid!("FFBS-123")
      ** (Ecto.NoResultsError)
  """

  def survey_from_radar_guid!(guid, answers \\ %{}, id \\ nil) do
    radar = @radars.get_radar_by_guid!(guid)
    trends_by_radar_guid = @radars.get_trends_by_radar_guid(guid)

    %Survey{
      id: id,
      radar_guid: guid,
      category_1_name: radar.category_1_name,
      category_2_name: radar.category_2_name,
      category_3_name: radar.category_3_name,
      category_4_name: radar.category_4_name,
      innermost_level_name: radar.innermost_level_name,
      intro: radar.intro,
      level_2_name: radar.level_2_name,
      level_3_name: radar.level_3_name,
      name: radar.name,
      outermost_level_name: radar.outermost_level_name,
      category_1_questions: trends_by_radar_guid |> survey_category_questions(1, answers),
      category_2_questions: trends_by_radar_guid |> survey_category_questions(2, answers),
      category_3_questions: trends_by_radar_guid |> survey_category_questions(3, answers),
      category_4_questions: trends_by_radar_guid |> survey_category_questions(4, answers)
    }
  end

  @doc """
  Build a survey schema from an existing response, pre-filling existing answers

  Raises `Ecto.NoResultsError` if the radar does not exist

  ## Examples

      iex> survey_from_survey_response!(survey_response)
      %Survey{}

      iex> survey_from_survey_response!(survey_response)
      ** (Ecto.NoResultsError)
  """

  def survey_from_survey_response!(%SurveyResponse{} = survey_response) do
    survey_answers =
      Repo.all(Ecto.assoc(survey_response, :survey_answers))
      |> Enum.map(fn survey_answer ->
        {survey_answer.radar_trend_guid, {survey_answer.id, survey_answer.answer}}
      end)
      |> Enum.into(%{})

    survey_from_radar_guid!(survey_response.radar_guid, survey_answers)
  end

  @spec survey_category_questions(
          trends_by_radar_guid :: %{
            required(number) => %{required(Ecto.UUID) => %TechRadar.Radars.Trend{}}
          },
          category :: number,
          answers :: %{optional(Ecto.UUID) => {number, number}}
        ) :: [%SurveyQuestion{}]
  defp survey_category_questions(trends_by_radar_guid, category, answer_data) do
    Map.get(trends_by_radar_guid, category, %{})
    |> Enum.map(fn {radar_trend_guid, trend} ->
      {id, answer} = Map.get(answer_data, radar_trend_guid, {nil, @default_answer})

      %SurveyQuestion{
        id: id,
        radar_trend_guid: radar_trend_guid,
        answer: answer,
        trend: %SurveyQuestion.Trend{
          name: trend.name,
          description: trend.description
        }
      }
    end)
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

  @doc """
  Creates a survey_response, but using attributes for a survey

  ## Examples

      iex> create_survey_response(%{field: value})
      {:ok, %SurveyResponse{}}

      iex> create_survey_response(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_survey_response_from_survey(attrs \\ %{}) do
    with changeset <- %Survey{} |> Survey.changeset(attrs),
         {:ok, survey} <- Ecto.Changeset.apply_action(changeset, :replace),
         attrs <- survey_response_params_from_survey(survey),
         {:ok, survey_response} <- create_survey_response(attrs) do
      {:ok, survey_response}
    else
      err -> err
    end
  end

  @doc """
  Updates a survey_response, but using attributes for a survey

  ## Examples

      iex> update_survey_response(survey_response, %{field: new_value})
      {:ok, %SurveyResponse{}}

      iex> update_survey_response(survey_response, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_survey_response_from_survey(%SurveyResponse{} = survey_response, attrs) do
    with survey <- survey_from_survey_response!(survey_response),
         changeset <- survey |> Survey.changeset(attrs),
         {:ok, updated_survey} <- Ecto.Changeset.apply_action(changeset, :replace),
         attrs <- survey_response_params_from_survey(updated_survey),
         {:ok, updated_survey_response} <- update_survey_response(survey_response, attrs) do
      {:ok, updated_survey_response}
    else
      err -> err
    end
  end

  @spec survey_response_params_from_survey(survey :: %Survey{}) :: map()
  defp survey_response_params_from_survey(%Survey{} = survey) do
    %{
      radar_guid: survey.radar_guid,
      survey_answers:
        [
          survey.category_1_questions,
          survey.category_2_questions,
          survey.category_3_questions,
          survey.category_4_questions
        ]
        |> List.flatten()
        |> Enum.map(fn survey_question ->
          %{
            id: survey_question.id,
            radar_trend_guid: survey_question.radar_trend_guid,
            answer: survey_question.answer
          }
        end)
    }
  end

  @doc """
  Gets a single survey_response.

  Raises `Ecto.NoResultsError` if the Survey response does not exist.

  ## Examples

      iex> get_survey_response!(123)
      %SurveyResponse{}

      iex> get_survey_response!(456)
      ** (Ecto.NoResultsError)

  """
  def get_survey_response!(id) do
    Repo.get!(SurveyResponse, id)
    |> Repo.preload(:survey_answers)
  end

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
