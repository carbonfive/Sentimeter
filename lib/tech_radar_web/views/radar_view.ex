defmodule TechRadarWeb.RadarView do
  use TechRadarWeb, :view
  alias TechRadar.Radars
  alias TechRadar.Radars.Radar
  alias TechRadar.Radars.RadarTrend

  @spec category_options(%Ecto.Changeset{data: %Radar{}}) :: %{required(String.t()) => integer()}
  def category_options(%Ecto.Changeset{data: radar}) do
    %{
      radar.category_1_name => 1,
      radar.category_2_name => 2,
      radar.category_3_name => 3,
      radar.category_4_name => 4
    }
  end

  def link_to_radar_trend_fields(trends) do
    changeset = Radars.change_radar(%Radar{radar_trends: [%RadarTrend{}]})
    form = Phoenix.HTML.FormData.to_form(changeset, [])
    fields = render_to_string(__MODULE__, "radar_trend_fields.html", f: form, trends: trends)
    link("Add Radar Trend", to: "#", "data-template": fields, id: "add-radar-trend")
  end
end
