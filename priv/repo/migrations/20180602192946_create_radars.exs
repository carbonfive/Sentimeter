defmodule TechRadar.Repo.Migrations.CreateRadars do
  use Ecto.Migration

  def change do
    create table(:radars) do
      add :intro, :text
      add :name, :string
      add :innermost_level_name, :string
      add :level_2_name, :string
      add :level_3_name, :string
      add :outermost_level_name, :string
      add :category_1_name, :string
      add :category_2_name, :string
      add :category_3_name, :string
      add :category_4_name, :string

      timestamps()
    end

  end
end
