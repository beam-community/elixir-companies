defmodule ElixirCompaniesWeb.Router do
  use ElixirCompaniesWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ElixirCompaniesWeb do
    pipe_through :browser

    get "/", CompanyController, :recent
    resources "/industries", IndustryController
    resources "/companies", CompanyController
    resources "/jobs", JobController
  end

  # Other scopes may use custom stacks.
  # scope "/api", ElixirCompaniesWeb do
  #   pipe_through :api
  # end
end
