defmodule Sentimeter.Responses.Answer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sentimeter.Responses.WouldRecommendAnswer
  alias Sentimeter.Responses.Response

  schema "answers" do
    field :survey_trend_guid, Ecto.UUID
    field :thoughts, :string
    field :would_recommend, WouldRecommendAnswer
    field :x, :integer
    field :y, :integer
    field :soft_delete, :boolean, default: false
    belongs_to(:response, Response)

    timestamps()
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:survey_trend_guid, :x, :y, :would_recommend, :thoughts, :soft_delete])
    |> validate_number(:x, greater_than: 0, less_than_or_equal_to: 5)
    |> validate_number(:y, greater_than: 0, less_than_or_equal_to: 5)
    |> validate_required([:survey_trend_guid, :x, :y, :would_recommend, :thoughts, :soft_delete])
  end
end
