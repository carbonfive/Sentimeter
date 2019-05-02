defmodule Sentimeter.Responses do
  @moduledoc """
  The Responses context.
  """

  import Ecto.Query, warn: false
  alias Sentimeter.Repo

  alias Sentimeter.Responses.Response

  @doc """
  Returns the list of matching responses.

  ## Examples

  iex> find_responses(survey_id: 1)
  [%Response{}, ...]

  """
  def find_responses(opts \\ []) do
    Response |> Ecto.Query.where(^opts) |> Repo.all() |> load_response_associations()
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
  def get_response!(id), do: Repo.get!(Response, id) |> load_response_associations()

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
    |> case do
      {:ok, response} -> {:ok, load_response_associations(response)}
      error -> error
    end
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
    |> case do
      {:ok, response} -> {:ok, load_response_associations(response)}
      error -> error
    end
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

  defp load_response_associations(response) do
    response
    |> Repo.preload(:survey)
    |> Repo.preload(:trend)
  end
end
