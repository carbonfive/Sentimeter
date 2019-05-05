defmodule Sentimeter.Responses.Response do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sentimeter.Responses.Answer
  @email_regex ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/

  schema "responses" do
    field :email, :string
    field :guid, Ecto.UUID, autogenerate: true
    field :survey_guid, Ecto.UUID
    has_many(:answers, Answer, on_delete: :delete_all, on_replace: :delete)

    timestamps()
  end

  @doc false
  def changeset(response, attrs) do
    response
    |> cast(attrs, [:email, :survey_guid])
    |> validate_format(:email, @email_regex)
    |> validate_required([:email, :survey_guid])
    |> cast_assoc(:answers)
  end
end
