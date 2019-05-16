defmodule Sentimeter.Reports.ReportsImpl do
  @moduledoc """
  The Reports context.
  """
  @behaviour Sentimeter.Reports
  alias Sentimeter.Reports.Report

  @doc """
  Gets a single report.

  Raises if the Report does not exist.

  ## Examples

      iex> get_report!(123)
      %Report{}

  """
  def get_report_by_survey_guid!(_) do
    %Report{}
  end
end
