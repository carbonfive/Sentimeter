defmodule Sentimeter.Responses.TrendChoiceForm do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sentimeter.Responses.TrendChoice

  embedded_schema do
    embeds_many(:trend_choices, TrendChoice, on_replace: :delete)
  end

  @doc false
  def changeset(trend_choice_form, attrs) do
    trend_choice_form
    |> cast(attrs, [])
    |> cast_embed(:trend_choices)
  end
end
