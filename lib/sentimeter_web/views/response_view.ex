defmodule SentimeterWeb.ResponseView do
  use SentimeterWeb, :view
  defp display_trend(%{trend: nil}), do: nil
  defp display_trend(%{trend: trend}), do: trend |> Map.get(:name)
end
