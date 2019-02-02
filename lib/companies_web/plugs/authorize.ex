defmodule CompaniesWeb.Plugs.Authorize do
  @moduledoc """
  A simple plug to prevent users without maintainer status from continuing
  """

  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  import Plug.Conn

  alias CompaniesWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(%{assigns: %{current_user: %{maintainer: true}}} = conn, _opts) do
    conn
  end

  def call(conn, _opts) do
    conn
    |> put_status(401)
    |> put_flash(:error, "Insufficient permissions")
    |> redirect(to: Routes.company_path(conn, :recent))
    |> halt()
  end
end
