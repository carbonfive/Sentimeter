defmodule Sentimeter.InvitationsTest.EmailTest do
  use ExUnit.Case
  alias Sentimeter.Invitations.Invitation

  test "invitation email" do
    to = "bob@example.com"
    invitation = %Invitation{email: to, response_guid: "7488a646-e31f-11e4-aace-600308960662"}
    email = Sentimeter.Invitations.Email.invitation_email(invitation)

    assert email.to == to
  end
end
