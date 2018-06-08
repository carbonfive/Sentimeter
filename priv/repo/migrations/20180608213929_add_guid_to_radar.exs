defmodule TechRadar.Repo.Migrations.AddGuidToRadar do
  use Ecto.Migration

  def change do
    alter table(:radars) do
      add(:guid, :uuid)
    end
  end
end
