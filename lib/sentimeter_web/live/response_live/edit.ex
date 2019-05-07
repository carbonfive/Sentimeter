defmodule SentimeterWeb.ResponseLive.Edit do
  use Phoenix.LiveView

  @responses Application.get_env(:sentimeter, :responses)
  @surveys Application.get_env(:sentimeter, :surveys)

  def mount(%{guid: guid}, socket) do
    response = @responses.get_response_by_guid!(guid)
    survey = @surveys.get_survey_by_guid!(response.survey_guid)

    trend_choice_form =
      @responses.trend_choice_form(response)
      |> @responses.change_trend_choice_form()

    {:ok,
     assign(socket, %{
       page: "intro",
       response: response,
       survey: survey,
       trend_choice_form: trend_choice_form
     })}
  end

  def render(assigns), do: SentimeterWeb.ResponseView.render("edit.html", assigns)

  def handle_event("intro-complete", _, socket) do
    {:noreply, assign(socket, page: "trend-choices")}
  end

  def handle_event("save-choices", %{"trend_choice_form" => trend_choice_form_params}, socket) do
    changeset =
      @responses.apply_trend_choice_form(socket.assigns[:response], trend_choice_form_params)

    trends_by_guid = @surveys.get_trends_by_survey_guid(socket.assigns[:response].survey_guid)

    {:noreply,
     assign(socket, page: "answers", changeset: changeset, trends_by_guid: trends_by_guid)}
  end

  def handle_event("validate-answers", %{"response" => response_params}, socket) do
    changeset =
      @responses.change_response(socket.assigns[:response], response_params)
      |> Map.put(:action, socket.assigns[:changeset].action)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save-answers", %{"response" => response_params}, socket) do
    case @responses.update_response(socket.assigns[:response], response_params) do
      {:ok, response} ->
        {:noreply, assign(socket, response: response, page: "finish")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
