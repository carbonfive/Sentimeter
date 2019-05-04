defmodule Sentimeter.Responses.WouldRecommendAnswer do
  @moduledoc """
  an enumerated type for answering if you would recommend

  Enumeration members:
  - `:yes`
  - `:no`
  - `:unsure`
  """

  @behaviour Ecto.Type

  answers =
    [
      :yes,
      :no,
      :unsure
    ]
    |> Enum.map(fn answer ->
      {answer, to_string(answer)}
    end)

  @doc "Returns the underlying schema type for the custom type"
  @spec type :: :would_recommend_answer
  def type, do: :would_recommend_answer

  @doc "Casts the given input to the custom type"
  @spec cast(atom | binary) :: {:ok, atom} | :error
  def cast(answer)

  for {atom, string} <- answers do
    def cast(unquote(atom)), do: {:ok, unquote(atom)}
    def cast(unquote(string)), do: {:ok, unquote(atom)}
  end

  def cast(_other), do: :error

  @doc "Loads the given term into a custom type"
  @spec load(binary) :: {:ok, atom}
  def load(answer)

  for {atom, string} <- answers do
    def load(unquote(string)), do: {:ok, unquote(atom)}
  end

  @doc "Dumps the given term into an Ecto native type"
  @spec dump(atom | binary) :: {:ok, binary} | :error
  def dump(answer)

  for {atom, string} <- answers do
    def dump(unquote(atom)), do: {:ok, unquote(string)}
    def dump(unquote(string)), do: {:ok, unquote(string)}
  end

  def dump(_other), do: :error
end
