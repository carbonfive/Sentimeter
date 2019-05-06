defmodule Sentimeter.Responses do
  @moduledoc """
  The Surveys context.
  """

  alias Sentimeter.Responses.Response

  @doc """
  Returns responses for the given survey

  ## Examples

      iex> responses_for_survey_guid("AADDBB-")
      [%Response{}, ...]

  """
  @callback responses_for_survey_guid(survey_guid :: Ecto.UUID.t()) :: [%Response{}]

  @doc """
  Gets a single response.

  Raises `Ecto.NoResultsError` if the Response does not exist.

  ## Examples

      iex> get_response!(123)
      %Response{}

      iex> get_response!(456)
      ** (Ecto.NoResultsError)

  """
  @callback get_response!(id :: number) :: %Response{} | no_return

  @doc """
  Gets a single response by guid

  Raises `Ecto.NoResultsError` if the Response does not exist.

  ## Examples

      iex> get_response_guid!("ABCDD-EED")
      %Response{}

      iex> get_response_guid!("ABCDD-FFF")
      ** (Ecto.NoResultsError)

  """
  @callback get_response_by_guid!(guid :: Ecto.UUID.t()) :: %Response{} | no_return

  @doc """
  Updates a response.

  ## Examples

      iex> update_response(response, %{field: new_value})
      {:ok, %Response{}}

      iex> update_response(response, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @callback update_response(response :: %Response{}, attrs :: Map.t()) ::
              {:ok, %Response{}} | {:error, %Ecto.Changeset{}}

  @doc """
  Deletes a Response.

  ## Examples

      iex> delete_response(response)
      {:ok, %Response{}}

      iex> delete_response(response)
      {:error, %Ecto.Changeset{}}

  """
  @callback delete_response(response :: %Response{}) ::
              {:ok, %Response{}} | {:error, %Ecto.Changeset{}}

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking response changes.

  ## Examples

      iex> change_response(response)
      %Ecto.Changeset{source: %Response{}}

  """
  @callback change_response(response :: %Response{}) :: %Ecto.Changeset{}

  @doc """
  Create multiple responses from list of emails for the given survey guid
  and send invitations

  ## Examples

      iex> create_responses([email], survey_guid)
      {:ok, [%Response{}]}

      iex> create_responses([bad_email], survey_guid)
      {:error, %Ecto.Changeset{}}

  """
  @callback create_responses(emails :: [String.t()], response_guid: Ecto.UUID.t()) ::
              {:ok, [%Response{}]} | {:error, %Ecto.Changeset{}}
end
