defmodule CompaniesWeb.UserController do
  use CompaniesWeb, :controller

  alias Companies.Accounts

  def for_hire(conn, params) do
    users = Accounts.for_hire(params)
    render(conn, :for_hire, users: users)
  end

  def profile(conn, _) do
    user = current_user(conn)
    render(conn, :profile, user: user)
  end
end
