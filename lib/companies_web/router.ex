defmodule CompaniesWeb.Router do
  use CompaniesWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {CompaniesWeb.LayoutView, :root}
    plug CompaniesWeb.Plugs.Session
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug CompaniesWeb.Plugs.Authorize
  end

  pipeline :admin do
    plug CompaniesWeb.Plugs.Authorize, admin: true
  end

  pipeline :set_locale do
    plug SetLocale, gettext: CompaniesWeb.Gettext, default_locale: "en"
  end

  if Mix.env() == :dev do
    scope "/" do
      pipe_through [:browser]

      forward "/sent_emails", Bamboo.SentEmailViewerPlug
    end
  end

  scope "/dashboard", CompaniesWeb do
    pipe_through [:browser, :auth]

    live_dashboard "/",
      metrics: CompaniesWeb.Telemetry,
      historical_data: {CompaniesWeb.MetricsHistory, :data, []}
  end

  scope "/", CompaniesWeb do
    pipe_through [:api]

    post "/sendgrid", SendGridController, :create
  end

  scope "/", CompaniesWeb do
    pipe_through [:browser, :set_locale]

    # Never called, required for set_locale and `/` redirect
    get "/", CompanyController, :dummy
  end

  scope "/:locale/", CompaniesWeb do
    pipe_through [:browser, :set_locale]

    scope "/" do
      pipe_through [:auth]

      resources "/companies", CompanyController, except: [:index, :show]
      resources "/jobs", JobController, except: [:index, :show]
      resources "/users", UserController, only: [:edit, :update]
    end

    get "/", CompanyController, :recent
    resources "/companies", CompanyController, only: [:index, :show]
    get "/jobs", JobController, :index
    get "/profile", UserController, :profile
    get "/for_hire", UserController, :for_hire
    get "/users/:id", UserController, :show

    scope "/admin", Admin do
      pipe_through [:admin]

      resources "/changes", PendingChangeController, only: [:index, :show, :update]
    end
  end

  scope "/auth", CompaniesWeb do
    pipe_through [:browser]

    get "/signout", AuthController, :signout
    get "/github", AuthController, :request
    get "/github/callback", AuthController, :callback
  end
end
