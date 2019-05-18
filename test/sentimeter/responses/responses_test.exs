defmodule Sentimeter.ResponsesTest do
  use Sentimeter.DataCase
  import Mox
  alias Sentimeter.InvitationsMock
  alias Sentimeter.SurveysMock
  alias Sentimeter.Responses.ResponsesImpl, as: Responses
  alias Sentimeter.Fixtures

  setup :verify_on_exit!

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
      attrs
      |> Enum.into(@valid_attrs)
      |> Fixtures.response()
    end

    test "responses_for_survey_guid/1 returns all responses matching survey guid" do
      matching_response = response_fixture(%{survey_guid: "7488a646-e31f-11e4-aace-600308960668"})
      not_matching_response = response_fixture()
      responses = Responses.responses_for_survey_guid("7488a646-e31f-11e4-aace-600308960668")
      assert Enum.member?(responses, matching_response) == true
      assert Enum.member?(responses, not_matching_response) == false
    end

    test "get_response!/1 returns the response with given id" do
      response = response_fixture()
      assert Responses.get_response!(response.id) == response
    end

    test "get_response_by_guid!/1 returns the response with given guid" do
      response = response_fixture()
      assert Responses.get_response_by_guid!(response.guid) == response
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

  defp setup_trend_choice_data(context) do
    guid_1 = "7488a646-e31f-11e4-aace-600308960662"
    guid_2 = "7488a646-e31f-11e4-aace-600308960668"
    guid_3 = "7488a646-e31f-11e4-aace-600308960669"
    guid_4 = "7488a646-e31f-11e4-aace-600308960671"

    response =
      Fixtures.response(%{
        answers: [
          Fixtures.answer_attrs(%{survey_trend_guid: guid_1}),
          Fixtures.answer_attrs(%{survey_trend_guid: guid_2, soft_delete: true})
        ]
      })

    answer_1 = Enum.find(response.answers, fn answer -> answer.survey_trend_guid == guid_1 end)
    answer_2 = Enum.find(response.answers, fn answer -> answer.survey_trend_guid == guid_2 end)
    first_trend = Fixtures.trend(%{name: "cool", description: "really cool"})
    second_trend = Fixtures.trend(%{name: "lame", description: "really lame"})
    third_trend = Fixtures.trend(%{name: "apple", description: "sucks 2019"})
    fourth_trend = Fixtures.trend(%{name: "orange", description: "sucks 2020"})

    %{
      guid_1: guid_1,
      guid_2: guid_2,
      guid_3: guid_3,
      guid_4: guid_4,
      answer_1: answer_1,
      answer_2: answer_2,
      first_trend: first_trend,
      second_trend: second_trend,
      third_trend: third_trend,
      fourth_trend: fourth_trend,
      response: response
    }
  end

  defp create_trend_choice_form(%{
         guid_1: guid_1,
         guid_2: guid_2,
         guid_3: guid_3,
         first_trend: first_trend,
         second_trend: second_trend,
         third_trend: third_trend,
         response: response
       }) do
    SurveysMock
    |> expect(:get_trends_by_survey_guid, fn guid ->
      assert guid == response.survey_guid

      %{
        guid_1 => first_trend,
        guid_2 => second_trend,
        guid_3 => third_trend
      }
    end)

    form = Responses.trend_choice_form(response)

    %{
      trend_choices: form.trend_choices
    }
  end

  defp create_trend_choice_attrs(%{
         guid_1: guid_1,
         guid_2: guid_2,
         guid_3: guid_3,
         guid_4: guid_4
       }) do
    %{
      trend_choice_attrs: %{
        trend_choices: [
          %{
            survey_trend_guid: guid_1,
            chosen: false
          },
          %{
            survey_trend_guid: guid_2,
            chosen: true
          },
          %{
            survey_trend_guid: guid_3,
            chosen: true
          },
          %{
            survey_trend_guid: guid_4
          }
        ]
      }
    }
  end

  describe "trend_choice_form/1 " do
    setup [:setup_trend_choice_data, :create_trend_choice_form]

    test "returns the right number of choices", %{trend_choices: trend_choices} do
      assert length(trend_choices) == 3
    end

    test "sets chosen = true if there is an active answer", %{
      trend_choices: trend_choices,
      guid_1: guid_1,
      first_trend: first_trend
    } do
      first_choice =
        trend_choices
        |> Enum.find(fn trend_choice -> trend_choice.survey_trend_guid == guid_1 end)

      assert first_choice != nil
      assert first_choice.chosen == true
      assert first_choice.trend.name == first_trend.name
      assert first_choice.trend.description == first_trend.description
    end

    test "sets chosen = false if there is an inactive answer", %{
      trend_choices: trend_choices,
      guid_2: guid_2,
      second_trend: second_trend
    } do
      second_choice =
        trend_choices
        |> Enum.find(fn trend_choice -> trend_choice.survey_trend_guid == guid_2 end)

      assert second_choice != nil
      assert second_choice.chosen == false
      assert second_choice.trend.name == second_trend.name
      assert second_choice.trend.description == second_trend.description
    end

    test "sets chosen = false if there are no answers", %{
      trend_choices: trend_choices,
      guid_3: guid_3,
      third_trend: third_trend
    } do
      third_choice =
        trend_choices
        |> Enum.find(fn trend_choice -> trend_choice.survey_trend_guid == guid_3 end)

      assert third_choice != nil
      assert third_choice.chosen == false
      assert third_choice.trend.name == third_trend.name
      assert third_choice.trend.description == third_trend.description
    end
  end

  describe "apply_trend_change_form/2" do
    setup [:setup_trend_choice_data, :create_trend_choice_attrs]

    test "creates the right number of answers", %{
      response: response,
      trend_choice_attrs: trend_choice_attrs
    } do
      new_response =
        Responses.apply_trend_choice_form(response, trend_choice_attrs)
        |> Ecto.Changeset.apply_changes()

      assert length(new_response.answers) == 3
    end

    test "modifies existing answers", %{
      response: response,
      trend_choice_attrs: trend_choice_attrs,
      guid_1: guid_1,
      guid_2: guid_2,
      answer_1: answer_1,
      answer_2: answer_2
    } do
      new_response =
        Responses.apply_trend_choice_form(response, trend_choice_attrs)
        |> Ecto.Changeset.apply_changes()

      new_answer_1 =
        Enum.find(new_response.answers, fn answer -> answer.survey_trend_guid == guid_1 end)

      new_answer_2 =
        Enum.find(new_response.answers, fn answer -> answer.survey_trend_guid == guid_2 end)

      assert new_answer_1 != nil
      assert new_answer_1.soft_delete == true
      assert new_answer_1.x == answer_1.x
      assert new_answer_1.y == answer_1.y
      assert new_answer_1.would_recommend == answer_1.would_recommend
      assert new_answer_1.thoughts == answer_1.thoughts

      assert new_answer_2 != nil
      assert new_answer_2.soft_delete == false
      assert new_answer_2.x == answer_2.x
      assert new_answer_2.y == answer_2.y
      assert new_answer_2.would_recommend == answer_2.would_recommend
      assert new_answer_2.thoughts == answer_2.thoughts
    end

    test "creates new answers", %{
      response: response,
      trend_choice_attrs: trend_choice_attrs,
      guid_3: guid_3
    } do
      new_response =
        Responses.apply_trend_choice_form(response, trend_choice_attrs)
        |> Ecto.Changeset.apply_changes()

      new_answer_3 =
        Enum.find(new_response.answers, fn answer -> answer.survey_trend_guid == guid_3 end)

      assert new_answer_3 != nil
      assert new_answer_3.soft_delete == false
    end
  end

  describe "send_reminders/1" do
    setup do
      InvitationsMock |> stub(:send_reminder, fn _ -> nil end)
      matching_response_guid = "7488a646-e31f-11e4-aace-600308960662"
      not_matching_response_guid = "7488a646-e31f-11e4-aace-600308960668"
      answer_guid_1 = "7488a646-e31f-11e4-aace-600308960669"
      answer_guid_2 = "7488a646-e31f-11e4-aace-600308960671"
      survey_guid = "7488a646-e31f-11e4-aace-600308960672"

      matching_response =
        Fixtures.response(%{
          guid: matching_response_guid,
          survey_guid: survey_guid,
          answers: []
        })

      not_matching_response =
        Fixtures.response(%{
          guid: not_matching_response_guid,
          survey_guid: survey_guid,
          answers: [
            Fixtures.answer_attrs(%{survey_trend_guid: answer_guid_1}),
            Fixtures.answer_attrs(%{survey_trend_guid: answer_guid_2})
          ]
        })

      %{
        matching_response: matching_response,
        not_matching_response: not_matching_response,
        survey_guid: survey_guid
      }
    end

    test "send_reminders/1 sends reminders to responses with no answers", %{
      survey_guid: survey_guid,
      matching_response: matching_response
    } do
      InvitationsMock
      |> expect(:send_reminder, 1, fn invitation_attrs ->
        assert invitation_attrs[:email] == matching_response.email
        assert invitation_attrs[:response_guid] == matching_response.guid
      end)

      assert {:ok, responses} = Responses.send_reminders_for_survey(survey_guid)
      assert Enum.find(responses, fn response -> response.id == matching_response.id end) != nil
    end

    test "send_reminders/1 does not send reminders to responses with answers", %{
      survey_guid: survey_guid,
      not_matching_response: not_matching_response
    } do
      assert {:ok, responses} = Responses.send_reminders_for_survey(survey_guid)

      assert Enum.find(responses, fn response -> response.id == not_matching_response.id end) ==
               nil
    end
  end
end
