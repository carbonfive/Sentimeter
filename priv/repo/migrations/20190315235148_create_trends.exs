defmodule Sentimeter.Repo.Migrations.CreateTrends do
  use Ecto.Migration

  def change do
    create table(:trends) do
      add :name, :string

      timestamps()
    end

  end
end
