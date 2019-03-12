defmodule Sentimeter.ResponsesTest do
  use Sentimeter.DataCase

  alias Sentimeter.Responses
  alias Sentimeter.Fixtures

  describe "responses" do
    alias Sentimeter.Responses.Response

    @valid_attrs %{email: "some email", x: 0.5, y: 0.5}
    @update_attrs %{email: "some updated email", x: 0.7, y: 0.7, survey_id: 2}
    @invalid_attrs %{email: nil, trend_id: nil, x: nil, y: nil}

    def response_fixture(attrs \\ %{}) do
      survey_id = Fixtures.survey() |> Map.get(:id)
      trend_id = Fixtures.trend() |> Map.get(:id)

      {:ok, response} =
        attrs
        |> Enum.into(%{survey_id: survey_id, trend_id: trend_id})
        |> Enum.into(@valid_attrs)
        |> Responses.create_response()

      response
    end

    test "get_response!/1 returns the response with given id" do
      response = response_fixture()
      assert Responses.get_response!(response.id) == response
    end

    test "create_response/1 with valid data creates a response" do
      attrs =
        %{
          survey_id: Map.get(Fixtures.survey(), :id),
          trend_id: Map.get(Fixtures.trend(), :id)
        }
        |> Enum.into(@valid_attrs)

      assert {:ok, %Response{} = response} = Responses.create_response(attrs)
      assert response.email == "some email"
      assert response.x == 0.5
    end

    test "create_response/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Responses.create_response(@invalid_attrs)
    end

    test "update_response/2 with valid data updates the response" do
      response = response_fixture()

      attrs =
        %{
          survey_id: Map.get(Fixtures.survey(), :id),
          trend_id: Map.get(Fixtures.trend(), :id)
        }
        |> Enum.into(@update_attrs)

      assert {:ok, %Response{} = response} = Responses.update_response(response, attrs)
      assert response.email == "some updated email"
      assert response.x == 0.7
      assert response.y == 0.7
    end

    test "update_response/2 with invalid data returns error changeset" do
      response = response_fixture()
      assert {:error, %Ecto.Changeset{}} = Responses.update_response(response, @invalid_attrs)
      assert response == Responses.get_response!(response.id)
    end

    test "delete_response/1 deletes the response" do
      response = response_fixture()
      assert {:ok, %Response{}} = Responses.delete_response(response)
      assert_raise Ecto.NoResultsError, fn -> Responses.get_response!(response.id) end
    end

    test "change_response/1 returns a response changeset" do
      response = response_fixture()
      assert %Ecto.Changeset{} = Responses.change_response(response)
    end
  end
end
