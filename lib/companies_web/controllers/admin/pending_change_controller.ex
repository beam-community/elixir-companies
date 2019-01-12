defmodule CompaniesWeb.Admin.PendingChangeController do
  use CompaniesWeb, :controller

  alias Companies.PendingChanges

  def index(conn, _params) do
    render(conn, "index.html", changes: pending_changes())
  end

  def update(conn, %{"id" => change_id}) do
    conn
    |> put_flash(:info, "Approval submitted")
    |> redirect(conn, to: Routes.admin_pending_changes(conn, :index))
  end

  defp pending_changes, do: PendingChanges.all()
end
