defmodule Sentimeter.Responses.ResponsesImpl do
  @moduledoc """
  The Responses context.
  """

  @behaviour Sentimeter.Responses

  import Ecto.Query, warn: false
  alias Sentimeter.Repo
  alias Ecto.Multi
  alias Sentimeter.Responses.Response
  @invitations Application.get_env(:sentimeter, :invitations)
  @surveys Application.get_env(:sentimeter, :surveys)

  @doc """
  Returns responses for the given survey

  ## Examples

      iex> responses_for_survey_guid("AADDBB-")
      [%Response{}, ...]

  """
  def responses_for_survey_guid(survey_guid) do
    Repo.all(responses_for_survey_query(survey_guid)) |> Repo.preload(:answers)
  end

  @doc """
  Gets a single response.

  Raises `Ecto.NoResultsError` if the Response does not exist.

  ## Examples

      iex> get_response!(123)
      %Response{}

      iex> get_response!(456)
      ** (Ecto.NoResultsError)

  """
  def get_response!(id), do: Repo.get!(Response, id) |> Repo.preload(:answers)

  @doc """
  Gets a single response by guid

  Raises `Ecto.NoResultsError` if the Response does not exist.

  ## Examples

      iex> get_response_guid!("ABCDD-EED")
      %Response{}

      iex> get_response_guid!("ABCDD-FFF")
      ** (Ecto.NoResultsError)

  """
  def get_response_by_guid!(guid) do
    Repo.get_by!(Response, guid: guid) |> Repo.preload(:answers)
  end

  @doc """
  Updates a response.

  ## Examples

      iex> update_response(response, %{field: new_value})
      {:ok, %Response{}}

      iex> update_response(response, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_response(%Response{} = response, attrs) do
    response
    |> Response.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Response.

  ## Examples

      iex> delete_response(response)
      {:ok, %Response{}}

      iex> delete_response(response)
      {:error, %Ecto.Changeset{}}

  """
  def delete_response(%Response{} = response) do
    Repo.delete(response)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking response changes.

  ## Examples

      iex> change_response(response)
      %Ecto.Changeset{source: %Response{}}

  """
  def change_response(%Response{} = response, attrs \\ %{}) do
    Response.changeset(response, attrs)
  end

  @doc """
  Create multiple responses from list of emails for the given survey guid
  and send invitations

  ## Examples

      iex> create_responses([email], survey_guid)
      {:ok, [%Response{}]}

      iex> create_responses([bad_email], survey_guid)
      {:error, %Ecto.Changeset{}}

  """
  def create_responses(emails, survey_guid) do
    result =
      Enum.with_index(emails)
      |> Enum.reduce(Multi.new(), fn {email, index}, multi ->
        Multi.insert(
          multi,
          {:response, index},
          %Response{}
          |> Response.changeset(%{email: email, survey_guid: survey_guid})
        )
      end)
      |> Repo.transaction()

    with {:ok, response_tuples} <- result do
      responses = response_tuples |> Enum.map(fn {_, response} -> response end)

      Task.Supervisor.async_stream_nolink(
        Sentimeter.Invitations.InvitationsSender,
        responses,
        fn response ->
          @invitations.send_invitation(%{email: response.email, response_guid: response.guid})
        end
      )
      |> Stream.run()

      {:ok, responses}
    else
      {:error, _, changeset, _} -> {:error, changeset}
    end
  end

  alias Sentimeter.Responses.Answer

  @doc """
  Returns the list of answer.

  ## Examples

      iex> list_answer()
      [%Answer{}, ...]

  """
  def list_answer do
    Repo.all(Answer)
  end

  @doc """
  Gets a single answer.

  Raises `Ecto.NoResultsError` if the Answer does not exist.

  ## Examples

      iex> get_answer!(123)
      %Answer{}

      iex> get_answer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_answer!(id), do: Repo.get!(Answer, id)

  @doc """
  Creates a answer.

  ## Examples

      iex> create_answer(%{field: value})
      {:ok, %Answer{}}

      iex> create_answer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_answer(attrs \\ %{}) do
    %Answer{}
    |> Answer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a answer.

  ## Examples

      iex> update_answer(answer, %{field: new_value})
      {:ok, %Answer{}}

      iex> update_answer(answer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_answer(%Answer{} = answer, attrs) do
    answer
    |> Answer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Answer.

  ## Examples

      iex> delete_answer(answer)
      {:ok, %Answer{}}

      iex> delete_answer(answer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_answer(%Answer{} = answer) do
    Repo.delete(answer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking answer changes.

  ## Examples

      iex> change_answer(answer)
      %Ecto.Changeset{source: %Answer{}}

  """
  def change_answer(%Answer{} = answer) do
    Answer.changeset(answer, %{})
  end

  alias Sentimeter.Responses.TrendChoiceForm
  alias Sentimeter.Responses.TrendChoice

  def trend_choice_form(%Response{} = response) do
    answered_guids =
      response.answers
      |> Enum.into(%{}, fn answer -> {answer.survey_trend_guid, !answer.soft_delete} end)

    %TrendChoiceForm{
      trend_choices:
        response.survey_guid
        |> @surveys.get_trends_by_survey_guid
        |> Enum.map(fn {survey_trend_guid, trend} ->
          %TrendChoice{
            survey_trend_guid: survey_trend_guid,
            chosen: Map.get(answered_guids, survey_trend_guid, false),
            trend: %TrendChoice.Trend{
              name: trend.name,
              description: trend.description
            }
          }
        end)
        |> Enum.sort_by(& &1.trend.name)
    }
  end

  def change_trend_choice_form(%TrendChoiceForm{} = trend_choice_form) do
    TrendChoiceForm.changeset(trend_choice_form, %{})
  end

  def apply_trend_choice_form(%Response{} = response, attrs \\ %{}) do
    trend_choice_form =
      %TrendChoiceForm{} |> TrendChoiceForm.changeset(attrs) |> Ecto.Changeset.apply_changes()

    answers_by_guid =
      response.answers
      |> Enum.map(fn answer -> {answer.survey_trend_guid, answer} end)
      |> Map.new()

    answers =
      trend_choice_form.trend_choices
      |> Enum.reduce([], fn trend_choice, existing_answers ->
        answer = Map.get(answers_by_guid, trend_choice.survey_trend_guid)

        cond do
          answer != nil ->
            [%{id: answer.id, soft_delete: !trend_choice.chosen} | existing_answers]

          trend_choice.chosen ->
            [
              %{soft_delete: false, survey_trend_guid: trend_choice.survey_trend_guid}
              | existing_answers
            ]

          true ->
            existing_answers
        end
      end)
      |> Enum.reverse()

    response |> Response.changeset(%{answers: answers})
  end

  def send_reminders_for_survey(survey_guid) do
    responses =
      Repo.all(
        from response in responses_for_survey_query(survey_guid),
          left_join: answer in assoc(response, :answers),
          where: is_nil(answer.id)
      )

    Task.Supervisor.async_stream_nolink(
      Sentimeter.Invitations.InvitationsSender,
      responses,
      fn response ->
        @invitations.send_reminder(%{email: response.email, response_guid: response.guid})
      end
    )
    |> Stream.run()

    {:ok, responses}
  end

  defp responses_for_survey_query(survey_guid) do
    from(response in Response, where: response.survey_guid == ^survey_guid)
  end
end
