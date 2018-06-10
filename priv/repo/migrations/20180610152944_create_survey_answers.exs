defmodule TechRadar.Repo.Migrations.CreateSurveyAnswers do
  use Ecto.Migration

  def change do
    create table(:survey_answers) do
      add :radar_guid, :uuid
      add :answers, {:map, :integer}

      timestamps()
    end

  end
end
