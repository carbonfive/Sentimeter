defmodule Sentimeter.Repo.Migrations.DropResponses do
  use Ecto.Migration

  def change do
    drop table("responses")
  end
end
