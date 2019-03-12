defmodule Sentimeter.Repo.Migrations.AddTaskToResponse do
  use Ecto.Migration

  def up do
    alter table("responses") do
      remove :trend
      add :trend_id, references(:trends, on_delete: :nothing)
    end
  end

  def down do
    alter table("responses") do
      remove :trend_id
      add :trend, :string
    end
  end
end
