defmodule Sentimeter.Responses do
  @moduledoc """
  The Surveys context.
  """

  alias Sentimeter.Responses.Response

  @doc """
  Returns the list of responses.

  ## Examples

      iex> list_responses()
      [%Response{}, ...]

  """
  @callback list_responses() :: [%Response{}]

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
  Creates a response.

  ## Examples

      iex> create_response(%{field: value})
      {:ok, %Response{}}

      iex> create_response(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @callback create_response() :: {:ok, %Response{}} | {:error, %Ecto.Changeset{}}
  @callback create_response(attrs :: Map.t()) :: {:ok, %Response{}} | {:error, %Ecto.Changeset{}}

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
end
