defmodule Sentimeter.Repo.Migrations.CreateAnswers do
  use Ecto.Migration

  def change do
    Ecto.Migration.execute(
      "CREATE TYPE would_recommend_answer AS ENUM ('yes','no', 'unsure')",
      "DROP TYPE would_recommend_answer"
    )

    create table(:answers) do
      add :survey_trend_guid, :uuid
      add :x, :integer
      add :y, :integer
      add :would_recommend, :would_recommend_answer
      add :thoughts, :text
      add :response_id, references(:responses, on_delete: :nothing)

      timestamps()
    end

    create index(:answers, [:response_id])
  end
end
