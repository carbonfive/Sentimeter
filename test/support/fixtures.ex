defmodule Sentimeter.Fixtures do
  @moduledoc """
  This module creates some fixtures to be used in testing.
  """
  alias Sentimeter.Surveys.SurveysImpl, as: Surveys

  def survey(attrs \\ %{}) do
    valid_attrs = %{
      closing: "some closing",
      intro: "some intro",
      name: "some name",
      section_1_desc: "some section_1_desc",
      section_2_desc: "some section_2_desc",
      x_max_label: "some x_max_label",
      x_min_label: "some x_min_label",
      y_max_label: "some y_max_label",
      y_min_label: "some y_min_label"
    }

    {:ok, survey} =
      attrs
      |> Enum.into(valid_attrs)
      |> Surveys.create_survey()

    survey
  end

  def trend(attrs \\ %{}) do
    valid_attrs = %{name: "some name", description: "terrible tech"}

    {:ok, trend} =
      attrs
      |> Enum.into(valid_attrs)
      |> Surveys.create_trend()

    trend
  end
end
