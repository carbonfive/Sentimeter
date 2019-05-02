defmodule Sentimeter.Repo.Migrations.AddDescriptionToTrends do
  use Ecto.Migration

  def change do
    alter table("trends") do
      add(:description, :text)
    end
  end
end
