defmodule CompaniesWeb.Admin.UserController do
  use CompaniesWeb, :controller

  alias Companies.Accounts

  def index(conn, _) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def toggle_admin(conn, %{"id" => id}) do
    user = Accounts.get!(id)

    case user == conn.assigns.current_user do
      true ->
        conn
        |> put_flash(:info, gettext("You can't change your own admin status"))
        |> redirect(to: Routes.user_path(conn, :index, locale(conn)))

      false ->
        Accounts.toggle_admin(user)
        redirect(conn, to: Routes.user_path(conn, :index, locale(conn)))
    end
  end
end
