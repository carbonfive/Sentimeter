defmodule Sentimeter.Reports.ReportResponse do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :name, :string
    field :email, :string
    field :thoughts, :string
  end

  @doc false
  def changeset(report_response, attrs) do
    report_response
    |> cast(attrs, [:name, :email, :thoughts])
    |> validate_required([:email, :thoughts])
  end
end
