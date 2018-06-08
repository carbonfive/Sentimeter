defmodule TechRadar.Radars.Radar do
  use Ecto.Schema
  import Ecto.Changeset
  alias TechRadar.Radars.Radar
  alias TechRadar.Radars.RadarTrend

  schema "radars" do
    field(:category_1_name, :string)
    field(:category_2_name, :string)
    field(:category_3_name, :string)
    field(:category_4_name, :string)
    field(:innermost_level_name, :string)
    field(:intro, :string)
    field(:level_2_name, :string)
    field(:level_3_name, :string)
    field(:name, :string)
    field(:outermost_level_name, :string)
    field(:guid, Ecto.UUID, autogenerate: true)
    has_many(:radar_trends, RadarTrend, on_delete: :delete_all)
    has_many(:trends, through: [:radar_trends, :trend])

    timestamps()
  end

  @doc false
  def changeset(%Radar{} = radar, attrs) do
    radar
    |> cast(attrs, [
      :intro,
      :name,
      :innermost_level_name,
      :level_2_name,
      :level_3_name,
      :outermost_level_name,
      :category_1_name,
      :category_2_name,
      :category_3_name,
      :category_4_name
    ])
    |> validate_required([
      :intro,
      :name,
      :innermost_level_name,
      :level_2_name,
      :level_3_name,
      :outermost_level_name,
      :category_1_name,
      :category_2_name,
      :category_3_name,
      :category_4_name
    ])
    |> cast_assoc(:radar_trends)
  end
end
