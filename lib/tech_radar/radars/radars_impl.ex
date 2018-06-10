defmodule TechRadar.Radars.RadarsImpl do
  @behaviour TechRadar.Radars

  @moduledoc """
  The Radars context.
  """

  import Ecto.Query, warn: false
  alias TechRadar.Repo

  alias TechRadar.Radars.Trend

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

  alias TechRadar.Radars.Radar

  @doc """
  Returns the list of radars.

  ## Examples

      iex> list_radars()
      [%Radar{}, ...]

  """
  def list_radars do
    Repo.all(Radar)
    |> Repo.preload(:radar_trends)
  end

  @doc """
  Gets a single radar.

  Raises `Ecto.NoResultsError` if the Radar does not exist.

  ## Examples

      iex> get_radar!(123)
      %Radar{}

      iex> get_radar!(456)
      ** (Ecto.NoResultsError)

  """
  def get_radar!(id) do
    Repo.get!(Radar, id)
    |> Repo.preload(:radar_trends)
  end

  @doc """
  Gets a single radar by GUID.

  Raises `Ecto.NoResultsError` if the Radar does not exist.

  ## Examples

      iex> get_radar_by_guid!("ADBCD-123")
      %Radar{}

      iex> get_radar_by_guid!("ADDJE-123")
      ** (Ecto.NoResultsError)

  """
  def get_radar_by_guid!(guid) do
    Repo.get_by!(Radar, guid: guid)
  end

  @doc """
  Gets all trends for a radar with given GUID, grouped by category

  ## Examples

      iex> get_trends_by_radar_guid("ADBCD-123")
      %{
        1: [%Trend{}]
      %}

  """
  def get_trends_by_radar_guid(guid) do
    query =
      from(
        trend in Trend,
        join: radar_trend in assoc(trend, :radar_trends),
        join: radar in assoc(radar_trend, :radar),
        where: radar.guid == ^guid,
        select: [radar_trend.category, {radar_trend.guid, trend}]
      )

    Repo.all(query)
    |> Enum.group_by(fn [category, _] -> category end, fn [_, guid_trend] -> guid_trend end)
    |> Enum.into(%{}, fn {category, guid_trends} -> {category, guid_trends |> Map.new()} end)
  end

  @doc """
  Creates a radar.

  ## Examples

      iex> create_radar(%{field: value})
      {:ok, %Radar{}}

      iex> create_radar(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_radar(attrs \\ %{}) do
    %Radar{}
    |> Radar.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a radar.

  ## Examples

      iex> update_radar(radar, %{field: new_value})
      {:ok, %Radar{}}

      iex> update_radar(radar, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_radar(%Radar{} = radar, attrs) do
    radar
    |> Radar.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Radar.

  ## Examples

      iex> delete_radar(radar)
      {:ok, %Radar{}}

      iex> delete_radar(radar)
      {:error, %Ecto.Changeset{}}

  """
  def delete_radar(%Radar{} = radar) do
    Repo.delete(radar)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking radar changes.

  ## Examples

      iex> change_radar(radar)
      %Ecto.Changeset{source: %Radar{}}

  """
  def change_radar(%Radar{} = radar) do
    Radar.changeset(radar, %{})
  end
end
