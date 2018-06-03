defmodule TechRadar.Repo.Migrations.CreateRadarTrends do
  use Ecto.Migration

  def change do
    create table(:radar_trends) do
      add :category, :integer
      add :radar_id, references(:radars, on_delete: :nothing)
      add :trend_id, references(:trends, on_delete: :nothing)

      timestamps()
    end

    create index(:radar_trends, [:radar_id])
    create index(:radar_trends, [:trend_id])
  end
end
