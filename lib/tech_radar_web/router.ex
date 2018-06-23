defmodule TechRadarWeb.Router do
  use TechRadarWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", TechRadarWeb.Api, as: :api do
    pipe_through(:api)
    resources("/reports", ReportController, param: "guid", only: [:show])
  end

  scope "/", TechRadarWeb do
    # Use the default browser stack
    pipe_through(:browser)
    resources("/trends", TrendController)
    resources("/radars", RadarController)
    resources("/surveys", SurveyController, param: "guid", only: [:show, :create])
    resources("/reports", ReportController, param: "guid", only: [:show])

    resources(
      "/survey_responses",
      SurveyResponseController,
      only: [:create, :show, :edit, :update]
    )

    get("/", PageController, :index)
  end
end
