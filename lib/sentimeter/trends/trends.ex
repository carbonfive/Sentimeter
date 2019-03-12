defmodule Sentimeter.Trends do
  @moduledoc """
  The Trends context.
  """

  import Ecto.Query, warn: false
  alias Sentimeter.Repo

  alias Sentimeter.Trends.Trend

  @doc """
  Returns the list of trends.

  ## Examples

      iex> list_trends()
      [%Trend{}, ...]

  """
  def list_trends do
    Repo.all(Trend)
  end

  @doc """
  Gets a single trend.

  Raises `Ecto.NoResultsError` if the Trend does not exist.

  ## Examples

      iex> get_trend!(123)
      %Trend{}

      iex> get_trend!(456)
      ** (Ecto.NoResultsError)

  """
  def get_trend!(id), do: Repo.get!(Trend, id)

  @doc """
  Creates a trend.

  ## Examples

      iex> create_trend(%{field: value})
      {:ok, %Trend{}}

      iex> create_trend(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_trend(attrs \\ %{}) do
    %Trend{}
    |> Trend.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a trend.

  ## Examples

      iex> update_trend(trend, %{field: new_value})
      {:ok, %Trend{}}

      iex> update_trend(trend, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_trend(%Trend{} = trend, attrs) do
    trend
    |> Trend.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Trend.

  ## Examples

      iex> delete_trend(trend)
      {:ok, %Trend{}}

      iex> delete_trend(trend)
      {:error, %Ecto.Changeset{}}

  """
  def delete_trend(%Trend{} = trend) do
    Repo.delete(trend)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking trend changes.

  ## Examples

      iex> change_trend(trend)
      %Ecto.Changeset{source: %Trend{}}

  """
  def change_trend(%Trend{} = trend) do
    Trend.changeset(trend, %{})
  end
end
