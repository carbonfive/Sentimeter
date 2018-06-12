defmodule TechRadar.Factory do
  use ExMachina.Ecto, repo: TechRadar.Repo
  alias TechRadar.Radars.Trend
  alias TechRadar.Radars.Radar
  alias TechRadar.Radars.RadarTrend
  alias TechRadar.Surveys.SurveyResponse
  alias TechRadar.Surveys.SurveyAnswer
  # Sample user factory
  # def user_factory do
  #   %User{
  #     name: "Test User 1",
  #     email: sequence(:email, &"testuser#{&1}@example.com"),
  #   }
  # end

  def trend_factory do
    %Trend{
      description: sequence(:description, &"Awesome thing ##{&1}"),
      name: sequence(:name, &"Trend ##{&1}")
    }
  end

  def radar_factory do
    %Radar{
      category_1_name: "some category_1_name",
      category_2_name: "some category_2_name",
      category_3_name: "some category_3_name",
      category_4_name: "some category_4_name",
      innermost_level_name: "some innermost_level_name",
      intro: "some intro",
      level_2_name: "some level_2_name",
      level_3_name: "some level_3_name",
      name: "some name",
      outermost_level_name: "some outermost_level_name",
      radar_trends: []
    }
  end

  def radar_trend_factory do
    %RadarTrend{
      category: sequence(:category, &rem(&1, 4)),
      trend: build(:trend)
    }
  end

  def survey_response_factory do
    %SurveyResponse{
      radar_guid: Ecto.UUID.generate(),
      survey_answers: []
    }
  end

  def survey_answer_factory do
    %SurveyAnswer{
      radar_trend_guid: Ecto.UUID.generate(),
      answer: sequence(:answer, &rem(&1, 4))
    }
  end
end
