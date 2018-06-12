defmodule TechRadar.Radars do
  @moduledoc """
  The Radars context.
  """

  alias TechRadar.Radars.Trend

  @doc """
  Returns the list of trends.

  ## Examples

      iex> list_trends()
      [%Trend{}, ...]

  """
  @callback list_trends() :: [%Trend{}]

  @doc """
  Gets a single trend.

  Raises `Ecto.NoResultsError` if the Trend does not exist.

  ## Examples

      iex> get_trend!(123)
      %Trend{}

      iex> get_trend!(456)
      ** (Ecto.NoResultsError)

  """
  @callback get_trend!(id :: number) :: %Trend{} | no_return

  @doc """
  Creates a trend.

  ## Examples

      iex> create_trend(%{field: value})
      {:ok, %Trend{}}

      iex> create_trend(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @callback create_trend() :: {:ok, %Trend{}} | {:error, %Ecto.Changeset{}}
  @callback create_trend(attrs :: Map.t()) :: {:ok, %Trend{}} | {:error, %Ecto.Changeset{}}

  @doc """
  Updates a trend.

  ## Examples

      iex> update_trend(trend, %{field: new_value})
      {:ok, %Trend{}}

      iex> update_trend(trend, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @callback update_trend(trend :: %Trend{}, attrs :: Map.t()) ::
              {:ok, %Trend{}} | {:error, %Ecto.Changeset{}}

  @doc """
  Deletes a Trend.

  ## Examples

      iex> delete_trend(trend)
      {:ok, %Trend{}}

      iex> delete_trend(trend)
      {:error, %Ecto.Changeset{}}

  """
  @callback delete_trend(trend :: %Trend{}) :: {:ok, %Trend{}} | {:error, %Ecto.Changeset{}}

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking trend changes.

  ## Examples

      iex> change_trend(trend)
      %Ecto.Changeset{source: %Trend{}}

  """
  @callback change_trend(trend :: %Trend{}) :: %Ecto.Changeset{}

  alias TechRadar.Radars.Radar

  @doc """
  Returns the list of radars.

  ## Examples

      iex> list_radars()
      [%Radar{}, ...]

  """
  @callback list_radars() :: [%Radar{}]

  @doc """
  Gets a single radar.

  Raises `Ecto.NoResultsError` if the Radar does not exist.

  ## Examples

      iex> get_radar!(123)
      %Radar{}

      iex> get_radar!(456)
      ** (Ecto.NoResultsError)

  """
  @callback get_radar!(id :: number) :: %Radar{} | no_return

  @doc """
  Gets a single radar by GUID.

  Raises `Ecto.NoResultsError` if the Radar does not exist.

  ## Examples

      iex> get_radar_by_guid!("ADBCD-123")
      %Radar{}

      iex> get_radar_by_guid!("ADDJE-123")
      ** (Ecto.NoResultsError)

  """
  @callback get_radar_by_guid!(guid :: Ecto.UUID.type()) :: %Radar{} | no_return

  @doc """
  Gets all trends for a radar with given GUID, grouped by category

  ## Examples

      iex> get_trends_by_radar_guid("ADBCD-123")
      %{
        1: [%Trend{}]
      %}

  """
  @callback get_trends_by_radar_guid(guid :: Ecto.UUID.type()) :: %{
              required(number) => %{required(Ecto.UUID) => %Trend{}}
            }

  @doc """
  Determine if the given radar trend guids cover the complete set of radar trends for the given radar guid

  ## Examples

      iex> get_trends_by_radar_guid("ADBCD-123")
      %{
        1: [%Trend{}]
      %}

  """
  @callback radar_trends_match_radar_guid(
              guid :: Ecto.UUID.type(),
              radar_trend_guids :: [Ecto.UUID.type()]
            ) :: true | false

  @doc """
  Creates a radar.

  ## Examples

      iex> create_radar(%{field: value})
      {:ok, %Radar{}}

      iex> create_radar(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @callback create_radar() :: {:ok, %Radar{}} | {:error, %Ecto.Changeset{}}
  @callback create_radar(attrs :: Map.t()) :: {:ok, %Radar{}} | {:error, %Ecto.Changeset{}}

  @doc """
  Updates a radar.

  ## Examples

      iex> update_radar(radar, %{field: new_value})
      {:ok, %Radar{}}

      iex> update_radar(radar, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @callback update_radar(radar :: %Radar{}, attrs :: Map.t()) ::
              {:ok, %Radar{}} | {:error, %Ecto.Changeset{}}

  @doc """
  Deletes a Radar.

  ## Examples

      iex> delete_radar(radar)
      {:ok, %Radar{}}

      iex> delete_radar(radar)
      {:error, %Ecto.Changeset{}}

  """
  @callback delete_radar(radar :: %Radar{}) :: {:ok, %Radar{}} | {:error, %Ecto.Changeset{}}

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking radar changes.

  ## Examples

      iex> change_radar(radar)
      %Ecto.Changeset{source: %Radar{}}

  """
  @callback change_radar(radar :: %Radar{}) :: %Ecto.Changeset{}
end
