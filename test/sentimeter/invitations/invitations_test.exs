defmodule Sentimeter.InvitationsTest do
  use ExUnit.Case
  use Bamboo.Test
  alias Sentimeter.Invitations.InvitationsImpl, as: Invitations

  test "send invitation with valid data sends message" do
    assert {:ok, %Bamboo.Email{} = email} =
             Invitations.send_invitation(%{
               email: "bob@example.com",
               response_guid: "7488a646-e31f-11e4-aace-600308960662"
             })

    assert_delivered_email(email)
  end

  test "send invitation with invalid data returns changeset, no send" do
    assert {:error, %Ecto.Changeset{}} =
             Invitations.send_invitation(%{
               response_guid: "7488a646-e31f-11e4-aace-600308960662"
             })

    assert_no_emails_delivered()
  end
end
