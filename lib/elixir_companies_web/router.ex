defmodule ElixirCompaniesWeb.Router do
  use ElixirCompaniesWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {ElixirCompaniesWeb.LayoutView, :root}
    plug SetLocale, gettext: ElixirCompaniesWeb.Gettext, default_locale: "en"
    plug ElixirCompaniesWeb.SetLocalePlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ElixirCompaniesWeb do
    pipe_through :browser

    # Never called, required for set_locale and `/` redirect
    get "/", CompanyController, :dummy
  end

  scope "/:locale/", ElixirCompaniesWeb do
    pipe_through :browser

    live "/", CompanyLive.Recent, :recent
    live "/companies", CompanyLive.Index, :index
    live "/companies/:name", CompanyLive.Show, :show
  end
end
