defmodule Sentimeter.Repo.Migrations.AddSoftDeleteToAnswer do
  use Ecto.Migration

  def change do
    alter table(:answers) do
      add(:soft_delete, :boolean, default: false, null: false)
    end
  end
end
