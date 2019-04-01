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

  pipeline :set_locale do
    plug SetLocale, gettext: CompaniesWeb.Gettext, default_locale: "en"
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug CompaniesWeb.Plugs.Authorize
  end

  pipeline :admin do
    plug CompaniesWeb.Plugs.Authorize, maintainer: true
  end

  scope "/", CompaniesWeb do
    pipe_through [:browser, :set_locale]

    get "/", CompanyController, :recent
    get "/browse", CompanyController, :index
  end

  scope "/:locale/", CompaniesWeb do
    pipe_through [:browser, :set_locale]

    get "/", CompanyController, :recent
    get "/hiring", Redirect, to: "/browse?type=hiring"
    get "/browse", CompanyController, :index

    scope "/" do
      pipe_through [:auth]

      resources "/companies", CompanyController, except: [:index, :show]
      resources "/jobs", JobController, except: [:index, :show]
    end

    scope "/admin", Admin do
      pipe_through [:admin]

      resources "/pending", PendingChangeController
    end
  end

  scope "/auth", CompaniesWeb do
    pipe_through [:browser]

    get "/signout", AuthController, :signout
    get "/github", AuthController, :request
    get "/github/callback", AuthController, :callback
  end
end
