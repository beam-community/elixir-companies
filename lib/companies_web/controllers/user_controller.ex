defmodule CompaniesWeb.UserController do
  use CompaniesWeb, :controller

  alias Companies.Accounts

  def for_hire(conn, params) do
    users = Accounts.for_hire(params)
    render(conn, "for_hire.html", users: users)
  end

  def profile(conn, _) do
    user = current_user(conn)

    case user do
      nil -> redirect(conn, to: "/")
      user -> render(conn, "profile.html", user: user)
    end
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get!(id)
    changeset = Accounts.change(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => params}) do
    user = Accounts.get!(id)

    case Accounts.update(user, params) do
      {:ok, _user} ->
        redirect(conn, to: "/profile")

      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end

    redirect(conn, to: "/profile")
  end
end
