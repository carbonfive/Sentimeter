# defmodule SentimeterWeb.ResponseControllerTest do
#   use SentimeterWeb.ConnCase

#   alias Sentimeter.Responses
#   alias Sentimeter.Fixtures

#   @create_attrs %{email: "some email", x: 0.5, y: 0.5}
#   @update_attrs %{email: "some updated email", x: 0.7, y: 0.7}
#   @invalid_attrs %{email: nil, trend_id: nil, x: nil, y: nil}

#   def fixture(:response, %{survey_id: survey_id, trend_id: trend_id}) do
#     {:ok, response} =
#       @create_attrs
#       |> Enum.into(%{survey_id: survey_id, trend_id: trend_id})
#       |> Responses.create_response()

#     response
#   end

#   def fixture(:survey) do
#     Fixtures.survey()
#   end

#   def fixture(:trend) do
#     Fixtures.trend()
#   end

#   describe "index" do
#     setup [:create_survey]

#     test "lists all responses", %{conn: conn, survey: survey} do
#       conn = get(conn, Routes.survey_response_path(conn, :index, survey))
#       assert html_response(conn, 200) =~ "Listing Responses"
#     end
#   end

#   describe "new response" do
#     setup [:create_survey]

#     test "renders form", %{conn: conn, survey: survey} do
#       conn = get(conn, Routes.survey_response_path(conn, :new, survey))
#       assert html_response(conn, 200) =~ "New Response"
#     end
#   end

#   describe "create response" do
#     setup [:create_survey, :create_trend]

#     test "redirects to show when data is valid", %{
#       conn: conn,
#       survey: survey,
#       trend: %{id: trend_id}
#     } do
#       attrs = @create_attrs |> Enum.into(%{trend_id: trend_id})

#       conn = post(conn, Routes.survey_response_path(conn, :create, survey), response: attrs)

#       assert %{id: id} = redirected_params(conn)
#       assert redirected_to(conn) == Routes.survey_response_path(conn, :show, survey, id)

#       conn = get(conn, Routes.survey_response_path(conn, :show, survey, id))
#       assert html_response(conn, 200) =~ "Show Response"
#     end

#     test "renders errors when data is invalid", %{conn: conn, survey: survey} do
#       conn =
#         post(conn, Routes.survey_response_path(conn, :create, survey), response: @invalid_attrs)

#       assert html_response(conn, 200) =~ "New Response"
#     end
#   end

#   describe "edit response" do
#     setup [:create_response]

#     test "renders form for editing chosen response", %{
#       conn: conn,
#       response: response,
#       survey: survey
#     } do
#       conn = get(conn, Routes.survey_response_path(conn, :edit, survey, response))
#       assert html_response(conn, 200) =~ "Edit Response"
#     end
#   end

#   describe "update response" do
#     setup [:create_response]

#     test "redirects when data is valid", %{
#       conn: conn,
#       response: response,
#       survey: survey,
#       trend: %{id: trend_id}
#     } do
#       conn =
#         put(conn, Routes.survey_response_path(conn, :update, survey, response),
#           response: @update_attrs |> Enum.into(%{trend_id: trend_id})
#         )

#       assert redirected_to(conn) == Routes.survey_response_path(conn, :show, survey, response)

#       conn = get(conn, Routes.survey_response_path(conn, :show, survey, response))
#       assert html_response(conn, 200) =~ "some updated email"
#     end

#     test "renders errors when data is invalid", %{conn: conn, response: response, survey: survey} do
#       conn =
#         put(conn, Routes.survey_response_path(conn, :update, survey, response),
#           response: @invalid_attrs
#         )

#       assert html_response(conn, 200) =~ "Edit Response"
#     end
#   end

#   describe "delete response" do
#     setup [:create_response]

#     test "deletes chosen response", %{conn: conn, response: response, survey: survey} do
#       conn = delete(conn, Routes.survey_response_path(conn, :delete, survey, response))
#       assert redirected_to(conn) == Routes.survey_response_path(conn, :index, survey)

#       assert_error_sent 404, fn ->
#         get(conn, Routes.survey_response_path(conn, :show, survey, response))
#       end
#     end
#   end

#   defp create_response(_) do
#     survey = fixture(:survey)
#     trend = fixture(:trend)

#     response =
#       fixture(:response, %{survey_id: Map.get(survey, :id), trend_id: Map.get(trend, :id)})

#     {:ok, response: response, survey: survey, trend: trend}
#   end

#   defp create_survey(_) do
#     {:ok, survey: fixture(:survey)}
#   end

#   defp create_trend(_) do
#     {:ok, trend: fixture(:trend)}
#   end
# end
