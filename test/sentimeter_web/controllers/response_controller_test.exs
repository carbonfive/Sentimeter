defmodule SentimeterWeb.ResponseControllerTest do
  use SentimeterWeb.ConnCase
  import Mox
  alias Sentimeter.ResponsesMock
  alias Sentimeter.Responses.Response

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def changeset(%Response{} = response, attrs \\ %{}) do
    Ecto.Changeset.change(response, attrs)
  end

  setup do
    ResponsesMock |> stub(:change_response, fn response -> changeset(response) end)
    :ok
  end

  setup :verify_on_exit!

  describe "index" do
    test "lists all responses", %{conn: conn} do
      ResponsesMock |> expect(:list_responses, fn -> [] end)
      conn = get(conn, Routes.response_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Responses"
    end
  end

  describe "new response" do
    test "renders form", %{conn: conn} do
      ResponsesMock |> expect(:change_response, 1, fn response -> changeset(response) end)
      conn = get(conn, Routes.response_path(conn, :new))
      assert html_response(conn, 200) =~ "New Response"
    end
  end

  describe "create response" do
    test "redirects to show when data is valid", %{conn: conn} do
      ResponsesMock |> expect(:create_response, fn _ -> {:ok, %Response{id: 1}} end)

      conn = post(conn, Routes.response_path(conn, :create), response: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.response_path(conn, :show, id)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      ResponsesMock
      |> expect(:create_response, fn _ ->
        {:error, changeset(%Response{})}
      end)

      conn = post(conn, Routes.response_path(conn, :create), response: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Response"
    end
  end

  describe "edit response" do
    test "renders form for editing chosen response", %{conn: conn} do
      ResponsesMock
      |> expect(:change_response, fn response -> changeset(response) end)
      |> expect(:get_response!, fn id -> %Response{id: id} end)

      conn = get(conn, Routes.response_path(conn, :edit, %Response{id: 1}))
      assert html_response(conn, 200) =~ "Edit Response"
    end
  end

  describe "update response" do
    test "redirects when data is valid", %{conn: conn} do
      ResponsesMock
      |> expect(:update_response, fn response, _params -> {:ok, response} end)
      |> expect(:get_response!, fn id -> %Response{id: id} end)

      conn =
        put(conn, Routes.response_path(conn, :update, %Response{id: 1}), response: @update_attrs)

      assert redirected_to(conn) == Routes.response_path(conn, :show, %Response{id: 1})
    end

    test "renders errors when data is invalid", %{conn: conn} do
      ResponsesMock
      |> expect(:update_response, fn response, params -> {:error, changeset(response, params)} end)
      |> expect(:get_response!, fn id -> %Response{id: id} end)

      conn =
        put(conn, Routes.response_path(conn, :update, %Response{id: 1}), response: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Response"
    end
  end

  describe "delete response" do
    test "deletes chosen response", %{conn: conn} do
      ResponsesMock
      |> expect(:delete_response, fn response -> {:ok, response} end)
      |> expect(:get_response!, fn id -> %Response{id: id} end)

      conn = delete(conn, Routes.response_path(conn, :delete, %Response{id: 1}))
      assert redirected_to(conn) == Routes.response_path(conn, :index)
    end
  end
end
