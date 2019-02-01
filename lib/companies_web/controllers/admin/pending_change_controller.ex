defmodule CompaniesWeb.Admin.PendingChangeController do
  use CompaniesWeb, :controller

  alias Companies.PendingChanges

  def index(conn, _params) do
    render(conn, "index.html", pending_changes: pending_changes())
  end

  def show(conn, %{"id" => change_id}) do
    pending_change = PendingChanges.get(change_id)
    render(conn, "show.html", pending_change: pending_change)
  end

  def update(conn, %{"id" => change_id}) do
    case PendingChanges.approve(change_id) do
      {:ok, _applied_changes} ->
        conn
        |> put_flash(:info, "Approval submitted")
        |> redirect(to: Routes.pending_change_path(conn, :index))

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Approval failed")
        |> redirect(to: Routes.pending_change_path(conn, :index))
    end
  end

  defp pending_changes, do: PendingChanges.all()
end
