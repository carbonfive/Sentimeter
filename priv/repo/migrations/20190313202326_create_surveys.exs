defmodule Sentimeter.Repo.Migrations.CreateSurveys do
  use Ecto.Migration

  def change do
    create table(:surveys) do
      add :name, :string
      add :x_min_label, :string
      add :x_max_label, :string
      add :y_min_label, :string
      add :y_max_label, :string
      add :intro, :string
      add :section_1_desc, :string
      add :section_2_desc, :string
      add :closing, :string

      timestamps()
    end

  end
end
