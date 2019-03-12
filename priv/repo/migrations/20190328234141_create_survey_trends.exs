defmodule Sentimeter.Repo.Migrations.CreateSurveyTrends do
  use Ecto.Migration

  def change do
    create table(:survey_trends) do
      add :survey_id, references(:surveys, on_delete: :nothing)
      add :trend_id, references(:trends, on_delete: :nothing)

      timestamps()
    end

    create index(:survey_trends, [:survey_id])
    create index(:survey_trends, [:trend_id])
  end
end
