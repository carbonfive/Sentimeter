defmodule SentimeterWeb.Router do
  use SentimeterWeb, :router

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug Phoenix.LiveView.Flash
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", SentimeterWeb do
    pipe_through(:browser)

    get("/", PageController, :index)

    resources "/surveys", SurveyController do
      resources "/responses", ResponseController, only: [:index, :create]
    end

    resources "/responses", ResponseController,
      param: "guid",
      only: [:show, :edit, :update, :delete]

    resources("/trends", TrendController)

    resources("/reports", ReportController, param: "guid", only: [:show])
  end

  scope "/api", SentimeterWeb.Api, as: :api do
    pipe_through(:api)
    resources("/reports", ReportController, param: "guid", only: [:show])
  end

  # Other scopes may use custom stacks.
  # scope "/api", SentimeterWeb do
  #   pipe_through :api
  # end
end
