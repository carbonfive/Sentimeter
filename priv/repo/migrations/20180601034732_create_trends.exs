defmodule TechRadar.Repo.Migrations.CreateTrends do
  use Ecto.Migration

  def change do
    create table(:trends) do
      add :name, :string
      add :description, :text

      timestamps()
    end

  end
end
