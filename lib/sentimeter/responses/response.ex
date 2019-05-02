defmodule Sentimeter.Responses.Response do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sentimeter.Surveys

  schema "responses" do
    field(:email, :string)
    field(:x, :float)
    field(:y, :float)
    belongs_to(:survey, Surveys.Survey)
    belongs_to(:trend, Surveys.Trend)

    timestamps()
  end

  @doc false
  def changeset(response, attrs) do
    response
    |> cast(attrs, [:x, :y, :trend_id, :email, :survey_id])
    |> validate_required([:x, :y, :trend_id, :email, :survey_id])
    |> validate_number(:x, greater_than_or_equal_to: 0, less_than_or_equal_to: 1)
    |> validate_number(:y, greater_than_or_equal_to: 0, less_than_or_equal_to: 1)
  end
end
