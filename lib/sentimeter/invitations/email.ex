defmodule Sentimeter.Invitations.Email do
  use Bamboo.Phoenix, view: SentimeterWeb.InvitationView
  alias Sentimeter.Invitations.Invitation

  @spec invitation_email(invitation :: %Invitation{}) :: %Bamboo.Email{}
  def invitation_email(%Invitation{} = invitation) do
    base_email()
    |> to(invitation.email)
    |> subject("You've been invited to take a survey with Sentimeter!")
    |> put_header("Reply-To", "sentimeter@carbonfive.com")
    |> render(:invitation_email, %{response_guid: invitation.response_guid})
  end

  @spec reminder_email(invitation :: %Invitation{}) :: %Bamboo.Email{}
  def reminder_email(%Invitation{} = invitation) do
    base_email()
    |> to(invitation.email)
    |> subject("Reminder: You have 1 day left to take your Sentimeter survey")
    |> put_header("Reply-To", "sentimeter@carbonfive.com")
    |> render(:reminder_email, %{response_guid: invitation.response_guid})
  end

  @spec base_email() :: Bamboo.Email.t()
  def base_email do
    new_email()
    # Set a default from
    |> from("sentimeter@carbonfive.com")
    # Set default layout
    |> put_html_layout({SentimeterWeb.LayoutView, "email.html"})
    # Set default text layout
    |> put_text_layout({SentimeterWeb.LayoutView, "email.text"})
  end
end
