defmodule CompaniesWeb.Router do
  use CompaniesWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug CompaniesWeb.Plugs.Menu
    plug CompaniesWeb.Plugs.SiteData
    plug CompaniesWeb.Plugs.Authorize
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug CompaniesWeb.Plugs.Authorize
  end

  scope "/", CompaniesWeb do
    pipe_through :browser

    get "/", CompanyController, :recent
    get "/hiring", CompanyController, :hiring
    resources "/industries", IndustryController
    resources "/companies", CompanyController do
      resources "/jobs", JobController
    end
    resources "/users", UserController
  end

  scope "/auth", CompaniesWeb do
    pipe_through [:browser, :auth]

    get "/signout", AuthController, :signout
    get "/github", AuthController, :request
    get "/github/callback", AuthController, :callback
  end
end
