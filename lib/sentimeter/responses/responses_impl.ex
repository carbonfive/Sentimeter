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

  @doc """
  Returns the list of responses.

  ## Examples

      iex> list_responses()
      [%Response{}, ...]

  """
  def list_responses do
    Repo.all(Response)
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
  def get_response!(id), do: Repo.get!(Response, id)

  @doc """
  Creates a response.

  ## Examples

      iex> create_response(%{field: value})
      {:ok, %Response{}}

      iex> create_response(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_response(attrs \\ %{}) do
    %Response{}
    |> Response.changeset(attrs)
    |> Repo.insert()
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
  def change_response(%Response{} = response) do
    Response.changeset(response, %{})
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
end
