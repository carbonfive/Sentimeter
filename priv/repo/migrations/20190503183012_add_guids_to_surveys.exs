defmodule Sentimeter.Repo.Migrations.AddGuidsToSurveys do
  use Ecto.Migration

  def change do
    alter table(:surveys) do
      add(:guid, :uuid)
    end

    alter table(:survey_trends) do
      add(:guid, :uuid)
    end
  end
end
