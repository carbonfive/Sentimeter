defmodule SentimeterWeb.LayoutView do
  use SentimeterWeb, :view

  def body_class(conn) do
    if Map.get(conn.assigns, :dark, false), do: "body--dark", else: "body"
  end

  def header_class(conn) do
    if Map.get(conn.assigns, :dark, false), do: "header--dark", else: "header"
  end
end
