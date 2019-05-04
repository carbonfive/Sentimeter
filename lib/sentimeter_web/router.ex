defmodule SentimeterWeb.Router do
  use SentimeterWeb, :router

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

  scope "/", SentimeterWeb do
    pipe_through(:browser)

    get("/", PageController, :index)

    resources "/surveys", SurveyController
    resources "/responses", ResponseController

    resources("/trends", TrendController)
  end

  scope "/api", SentimeterWeb do
    pipe_through(:api)
  end

  # Other scopes may use custom stacks.
  # scope "/api", SentimeterWeb do
  #   pipe_through :api
  # end
end
