defmodule CompaniesWeb.Router do
  use CompaniesWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug CompaniesWeb.Plugs.Session
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
    get "/hiring", Redirect, to: "/browse?type=hiring"
    get "/browse", CompanyController, :index
  end

  scope "/auth", CompaniesWeb do
    pipe_through [:browser]

    get "/signout", AuthController, :signout
    get "/github", AuthController, :request
    get "/github/callback", AuthController, :callback
  end

  scope "/admin", CompaniesWeb do
    pipe_through [:browser, :auth]

    resources "/pending", Admin.PendingChangeController
    resources "/companies", CompanyController
    resources "/jobs", JobController
  end
end
