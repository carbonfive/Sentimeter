defmodule SentimeterWeb.ResponseLive.Edit do
  use Phoenix.LiveView
  alias RedixPool, as: Redis

  @responses Application.get_env(:sentimeter, :responses)
  @surveys Application.get_env(:sentimeter, :surveys)

  def mount(%{session_guid: session_guid, guid: guid}, socket) do
    cached_value = Redis.command(["GET", session_guid])

    case cached_value do
      {:ok, value} when is_binary(value) and byte_size(value) > 0 ->
        {:ok, assign(socket, :erlang.binary_to_term(value))}

      _ ->
        response = @responses.get_response_by_guid!(guid)
        survey = @surveys.get_survey_by_guid!(response.survey_guid)

        trend_choice_form =
          @responses.trend_choice_form(response)
          |> @responses.change_trend_choice_form()

        {:ok,
         assign(socket, %{
           session_guid: session_guid,
           page: "intro",
           response: response,
           survey: survey,
           trend_choice_form: trend_choice_form
         })}
    end
  end

  def render(assigns), do: SentimeterWeb.ResponseView.render("edit.html", assigns)

  def handle_event(event, params, socket) do
    response = handle_event_internal(event, params, socket)

    case response do
      {:noreply, socket} ->
        Task.Supervisor.start_child(SentimeterWeb.StateCacher, fn ->
          Redis.command([
            "SET",
            socket.assigns[:session_guid],
            :erlang.term_to_binary(socket.assigns)
          ])
        end)

        {:noreply, socket}

      other_response ->
        other_response
    end
  end

  defp handle_event_internal("intro-complete", _, socket) do
    {:noreply, assign(socket, page: "trend-choices")}
  end

  defp handle_event_internal(
         "save-choices",
         %{"trend_choice_form" => trend_choice_form_params},
         socket
       ) do
    changeset =
      @responses.apply_trend_choice_form(socket.assigns[:response], trend_choice_form_params)

    trends_by_guid = @surveys.get_trends_by_survey_guid(socket.assigns[:response].survey_guid)

    {:noreply,
     assign(socket, page: "answers", changeset: changeset, trends_by_guid: trends_by_guid)}
  end

  defp handle_event_internal("validate-answers", %{"response" => response_params}, socket) do
    changeset =
      @responses.change_response(socket.assigns[:response], response_params)
      |> Map.put(:action, socket.assigns[:changeset].action)

    {:noreply, assign(socket, changeset: changeset)}
  end

  defp handle_event_internal("save-answers", %{"response" => response_params}, socket) do
    case @responses.update_response(socket.assigns[:response], response_params) do
      {:ok, response} ->
        {:noreply, assign(socket, response: response, page: "finish")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
