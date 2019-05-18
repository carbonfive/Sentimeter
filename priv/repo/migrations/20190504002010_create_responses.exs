defmodule Sentimeter.Repo.Migrations.CreateResponses do
  use Ecto.Migration

  def change do
    create table(:responses) do
      add :email, :string
      add :survey_guid, :uuid
      add :guid, :uuid

      timestamps()
    end
  end
end
