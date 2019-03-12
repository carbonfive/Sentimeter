defmodule Sentimeter.Repo.Migrations.CreateResponses do
  use Ecto.Migration

  def change do
    create table(:responses) do
      add :x, :float
      add :y, :float
      add :trend, :string
      add :email, :string
      add :survey_id, references(:surveys, on_delete: :nothing)

      timestamps()
    end

    create index(:responses, [:survey_id])
  end
end
