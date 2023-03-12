defmodule ElixirCompaniesWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use ElixirCompaniesWeb, :controller
      use ElixirCompaniesWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: ElixirCompaniesWeb

      import Phoenix.LiveView.Controller
      import Plug.Conn
      import ElixirCompaniesWeb.Gettext
      import ElixirCompaniesWeb.UserHelpers
      import ElixirCompaniesWeb.LocaleHelpers

      alias ElixirCompaniesWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/elixir_companies_web/templates",
        namespace: ElixirCompaniesWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Use all HTML functionality (forms, tags, etc)
      alias ElixirCompaniesWeb.Router.Helpers, as: Routes
      unquote(view_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {ElixirCompaniesWeb.LayoutView, :live}

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import ElixirCompaniesWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView helpers (live_render, live_component, live_patch, etc)
      import Phoenix.Component
      import Phoenix.View

      import ElixirCompaniesWeb.ErrorHelpers
      import ElixirCompanies.URLSchemer
      import ElixirCompaniesWeb.Gettext
      import ElixirCompaniesWeb.SiteHelpers
      import ElixirCompaniesWeb.UserHelpers
      import ElixirCompaniesWeb.LocaleHelpers
      import Phoenix.LiveView.Helpers
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
