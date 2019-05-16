defmodule Sentimeter.Reports do
  @moduledoc """
  The Reports context.
  """

  alias Sentimeter.Reports.Report

  @doc """
  Gets a single report.

  Raises if the Report does not exist.

  ## Examples

      iex> get_report!(123)
      %Report{}

  """
  @callback get_report_by_survey_guid!(survey_guid :: Ecto.UUID) :: %Report{} | no_return
end
