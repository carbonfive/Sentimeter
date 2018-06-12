defmodule TechRadar.Repo.Migrations.RemoveAnswersFromSurveyResponses do
  use Ecto.Migration

  def change do
    alter table(:survey_responses) do
      remove(:answers)
    end
  end
end
