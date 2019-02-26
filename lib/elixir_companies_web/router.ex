defmodule ElixirCompaniesWeb.Router do
  use ElixirCompaniesWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ElixirCompaniesWeb.Plugs.Session
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug ElixirCompaniesWeb.Plugs.Authorize
  end

  scope "/", ElixirCompaniesWeb do
    pipe_through :browser

    get "/", CompanyController, :recent
    get "/hiring", CompanyController, :hiring
    get "/browse", CompanyController, :index
    resources "/jobs", JobController
    resources "/users", UserController
  end

  scope "/auth", ElixirCompaniesWeb do
    pipe_through [:browser]

    get "/signout", AuthController, :signout
    get "/github", AuthController, :request
    get "/github/callback", AuthController, :callback
    resources "/companies", CompanyController, only: [:new, :create]
  end

  scope "/admin", ElixirCompaniesWeb.Admin do
    pipe_through [:browser]

    resources "/pending", PendingChangeController
  end
end
