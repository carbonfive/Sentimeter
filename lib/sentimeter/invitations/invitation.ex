defmodule Sentimeter.Invitations.Invitation do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :email, :string
    field :response_guid, Ecto.UUID
  end

  @doc false
  def changeset(invitation, attrs) do
    invitation
    |> cast(attrs, [:email, :response_guid])
    |> validate_required([:email, :response_guid])
  end
end
