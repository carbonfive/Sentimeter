defmodule TechRadar.Repo.Migrations.RecreateSurveyAnswers do
  use Ecto.Migration

  def change do
    create table(:survey_answers) do
      add(:radar_trend_guid, :uuid)
      add(:answer, :integer)
      add(:survey_response_id, references(:survey_responses, on_delete: :nothing))

      timestamps()
    end

    create(index(:survey_answers, [:survey_response_id]))
  end
end
