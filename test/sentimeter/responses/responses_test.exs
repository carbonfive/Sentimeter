defmodule Sentimeter.ResponsesTest do
  use Sentimeter.DataCase
  import Mox
  alias Sentimeter.InvitationsMock
  alias Sentimeter.Responses.ResponsesImpl, as: Responses

  describe "responses" do
    alias Sentimeter.Responses.Response

    @valid_attrs %{
      email: "example@example.com",
      survey_guid: "7488a646-e31f-11e4-aace-600308960662"
    }
    @update_attrs %{
      email: "new-example@example.com",
      survey_guid: "7488a646-e31f-11e4-aace-600308960668"
    }
    @invalid_attrs %{email: nil, guid: nil, survey_guid: nil}

    def response_fixture(attrs \\ %{}) do
      {:ok, response} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Responses.create_response()

      response
    end

    test "list_responses/0 returns all responses" do
      response = response_fixture()
      assert Responses.list_responses() == [response]
    end

    test "get_response!/1 returns the response with given id" do
      response = response_fixture()
      assert Responses.get_response!(response.id) == response
    end

    test "create_response/1 with valid data creates a response" do
      assert {:ok, %Response{} = response} = Responses.create_response(@valid_attrs)
      assert response.email == "example@example.com"
      assert response.survey_guid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_response/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Responses.create_response(@invalid_attrs)
    end

    test "update_response/2 with valid data updates the response" do
      response = response_fixture()
      assert {:ok, %Response{} = response} = Responses.update_response(response, @update_attrs)
      assert response.email == "new-example@example.com"
      assert response.survey_guid == "7488a646-e31f-11e4-aace-600308960668"
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

    test "create_responses/2 with valid data creates responses" do
      InvitationsMock |> stub(:send_invitation, fn _ -> nil end)

      valid_emails = [
        "apples@apples.com",
        "oranges@oranges.com",
        "cheese@cheese.com"
      ]

      survey_guid = "7488a646-e31f-11e4-aace-600308960668"

      assert {:ok, responses} = Responses.create_responses(valid_emails, survey_guid)

      assert length(responses) == length(valid_emails)

      Enum.zip(responses, valid_emails)
      |> Enum.each(fn {response, valid_email} ->
        assert %Response{} = response
        assert response.email == valid_email
        assert response.survey_guid == survey_guid
      end)
    end

    test "create_responses/2 with valid data sends invitations" do
      valid_emails = [
        "apples@apples.com",
        "oranges@oranges.com",
        "cheese@cheese.com"
      ]

      InvitationsMock |> expect(:send_invitation, length(valid_emails), fn _ -> nil end)

      survey_guid = "7488a646-e31f-11e4-aace-600308960668"

      Responses.create_responses(valid_emails, survey_guid)
    end

    test "create_responses/2 with invalid data creates no responses and returns errors" do
      invalid_emails = [
        "cheese",
        "oranges@oranges.com",
        "cheese@cheese.com"
      ]

      survey_guid = "7488a646-e31f-11e4-aace-600308960668"

      assert {:error, %Ecto.Changeset{}} = Responses.create_responses(invalid_emails, survey_guid)
    end
  end

  describe "answer" do
    alias Sentimeter.Responses.Answer

    @valid_attrs %{
      survey_trend_guid: "7488a646-e31f-11e4-aace-600308960662",
      thoughts: "some thoughts",
      would_recommend: :yes,
      x: 1,
      y: 2
    }
    @update_attrs %{
      survey_trend_guid: "7488a646-e31f-11e4-aace-600308960668",
      thoughts: "some updated thoughts",
      would_recommend: :no,
      x: 3,
      y: 4
    }
    @invalid_attrs %{survey_trend_guid: nil, thoughts: nil, would_recommend: nil, x: nil, y: nil}

    def answer_fixture(attrs \\ %{}) do
      {:ok, answer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Responses.create_answer()

      answer
    end

    test "list_answer/0 returns all answer" do
      answer = answer_fixture()
      assert Responses.list_answer() == [answer]
    end

    test "get_answer!/1 returns the answer with given id" do
      answer = answer_fixture()
      assert Responses.get_answer!(answer.id) == answer
    end

    test "create_answer/1 with valid data creates a answer" do
      assert {:ok, %Answer{} = answer} = Responses.create_answer(@valid_attrs)
      assert answer.survey_trend_guid == "7488a646-e31f-11e4-aace-600308960662"
      assert answer.thoughts == "some thoughts"
      assert answer.would_recommend == :yes
      assert answer.x == 1
      assert answer.y == 2
    end

    test "create_answer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Responses.create_answer(@invalid_attrs)
    end

    test "update_answer/2 with valid data updates the answer" do
      answer = answer_fixture()
      assert {:ok, %Answer{} = answer} = Responses.update_answer(answer, @update_attrs)
      assert answer.survey_trend_guid == "7488a646-e31f-11e4-aace-600308960668"
      assert answer.thoughts == "some updated thoughts"
      assert answer.would_recommend == :no
      assert answer.x == 3
      assert answer.y == 4
    end

    test "update_answer/2 with invalid data returns error changeset" do
      answer = answer_fixture()
      assert {:error, %Ecto.Changeset{}} = Responses.update_answer(answer, @invalid_attrs)
      assert answer == Responses.get_answer!(answer.id)
    end

    test "delete_answer/1 deletes the answer" do
      answer = answer_fixture()
      assert {:ok, %Answer{}} = Responses.delete_answer(answer)
      assert_raise Ecto.NoResultsError, fn -> Responses.get_answer!(answer.id) end
    end

    test "change_answer/1 returns a answer changeset" do
      answer = answer_fixture()
      assert %Ecto.Changeset{} = Responses.change_answer(answer)
    end
  end
end
