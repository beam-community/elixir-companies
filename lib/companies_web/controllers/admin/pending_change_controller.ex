defmodule CompaniesWeb.Admin.PendingChangeController do
  use CompaniesWeb, :controller

  require Logger

  alias Companies.PendingChanges

  def index(conn, _params) do
    render(conn, "index.html", pending_changes: pending_changes())
  end

  def show(conn, %{"id" => change_id}) do
    pending_change = PendingChanges.get(change_id)

    render(conn, "show.html", pending_change: pending_change)
  end

  def update(conn, %{"id" => change_id, "approval" => approval}) do
    case PendingChanges.act(change_id, approval) do
      {:ok, :rejected} ->
        conn
        |> put_flash(:info, "Changes rejected")
        |> redirect(to: Routes.pending_change_path(conn, :index))

      {:ok, _approved_changes} ->
        conn
        |> put_flash(:info, "Changes submitted")
        |> redirect(to: Routes.pending_change_path(conn, :index))

      {:error, reason} ->
        Logger.error(reason)

        conn
        |> put_flash(:error, "Changes failed")
        |> redirect(to: Routes.pending_change_path(conn, :index))
    end
  end

  defp pending_changes, do: PendingChanges.all()
end
