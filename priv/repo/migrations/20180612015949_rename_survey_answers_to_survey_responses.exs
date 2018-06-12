defmodule TechRadar.Repo.Migrations.RenameSurveyAnswersToSurveyResponses do
  use Ecto.Migration

  def change do
    rename(table(:survey_answers), to: table(:survey_responses))
  end
end
