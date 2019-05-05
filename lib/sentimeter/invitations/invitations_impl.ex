defmodule Sentimeter.Invitations.InvitationsImpl do
  @behaviour Sentimeter.Invitations

  alias Sentimeter.Invitations.Invitation
  alias Sentimeter.Invitations.Email
  alias Sentimeter.Invitations.Mailer
  import Ecto.Changeset

  @doc """
  Send an invitation
  ## Examples

      iex> send_invitations(%{email: email, response_guid: response_guid})
      {:ok, %Bamboo.Email{}}

      iex> send_invitations(%{field: bad_value})
      {:error, %Ecto.Changeset}

  """
  def send_invitation(invitation_attrs) do
    invitation_changes =
      %Invitation{}
      |> Invitation.changeset(invitation_attrs)

    case invitation_changes.valid? do
      true ->
        {:ok,
         apply_changes(invitation_changes) |> Email.invitation_email() |> Mailer.deliver_now()}

      false ->
        {:error, invitation_changes}
    end
  end
end
