defmodule CompaniesWeb.Router do
  use CompaniesWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {CompaniesWeb.LayoutView, :root}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :set_locale do
    plug SetLocale, gettext: CompaniesWeb.Gettext, default_locale: "en"
  end

  scope "/", CompaniesWeb do
    pipe_through [:browser, :set_locale]

    # Never called, required for set_locale and `/` redirect
    get "/", CompanyController, :dummy
  end

  scope "/:locale/", CompaniesWeb do
    pipe_through [:browser, :set_locale]

    scope "/" do
      resources "/companies", CompanyController, except: [:index, :show]
    end

    get "/", CompanyController, :recent
    live "/companies", CompanyLive
    resources "/companies", CompanyController, only: [:show]
  end
end
