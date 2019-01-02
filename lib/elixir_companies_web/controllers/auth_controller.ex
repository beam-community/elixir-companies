defmodule ElixirCompaniesWeb.AuthController do
  use ElixirCompaniesWeb, :controller
  plug Ueberauth
  alias ElixirCompanies.Accounts

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{
      token: auth.credentials.token,
      email: auth.info.email
    }
    signin(conn, user_params)
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: Routes.company_path(conn, :recent))
  end

  defp signin(conn, user_params) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.company_path(conn, :recent))
      {:error, reason} ->
        conn
        |> put_flash(:error, "Error: #{reason}")
        |> redirect(to: Routes.company_path(conn, :index))
    end
  end
end
