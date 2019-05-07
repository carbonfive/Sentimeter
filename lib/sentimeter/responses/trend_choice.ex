defmodule Sentimeter.Responses.TrendChoice do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :survey_trend_guid, Ecto.UUID
    field :chosen, :boolean

    embeds_one :trend, Trend do
      field :name, :string
      field :description, :string
    end
  end

  @doc false
  def changeset(trend_choice, attrs) do
    trend_choice
    |> cast(attrs, [:survey_trend_guid, :chosen])
    |> validate_required([:survey_trend_guid, :chosen])
  end
end
