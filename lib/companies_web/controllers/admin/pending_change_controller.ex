defmodule CompaniesWeb.Admin.PendingChangeController do
  use CompaniesWeb, :controller

  alias Companies.PendingChanges

  def index(conn, _params) do
    render(conn, "index.html", change: pending_changes())
  end

  def show(conn, _params) do
    render(conn, "show.html")
  end

  def update(conn, %{"id" => change_id}) do
    case PendingChanges.approve(change_id) do
      {:ok, _applied_changes} ->
        conn
        |> put_flash(:info, "Approval submitted")
        |> redirect(to: Routes.pending_change_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Approval failed")
        |> redirect(to: Routes.pending_change_path(conn, :index))
    end
  end

  defp pending_changes, do: PendingChanges.all()
end
