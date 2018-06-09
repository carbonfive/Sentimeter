defmodule TechRadar.Repo.Migrations.AddGuidToRadarTrends do
  use Ecto.Migration

  def change do
    alter table(:radar_trends) do
      add(:guid, :uuid)
    end
  end
end
