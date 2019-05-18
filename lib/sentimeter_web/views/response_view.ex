defmodule SentimeterWeb.ResponseView do
  use SentimeterWeb, :view

  def index_string(fa) do
    index = fa.id |> String.trim_leading("response_answers_") |> Integer.parse() |> elem(0)
    "#{index + 1}"
  end
end
