defmodule CompaniesWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use CompaniesWeb, :controller
      use CompaniesWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: CompaniesWeb

      import Plug.Conn
      import CompaniesWeb.Gettext
      import CompaniesWeb.UserHelpers
      import CompaniesWeb.LocaleHelpers

      alias CompaniesWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/companies_web/templates",
        namespace: CompaniesWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import CompaniesWeb.ErrorHelpers
      import CompaniesWeb.Gettext
      import CompaniesWeb.SiteHelpers
      import CompaniesWeb.UserHelpers
      import CompaniesWeb.LocaleHelpers

      alias CompaniesWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import CompaniesWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
