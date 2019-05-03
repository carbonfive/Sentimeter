defmodule Sentimeter.Repo.Migrations.ConvertSurveyFieldsToText do
  use Ecto.Migration

  def change do
    alter table("surveys") do
      modify :intro, :text
      modify :section_1_desc, :text
      modify :section_2_desc, :text
      modify :closing, :text
    end
  end
end
