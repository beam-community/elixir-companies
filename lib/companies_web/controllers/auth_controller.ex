defmodule CompaniesWeb.AuthController do
  use CompaniesWeb, :controller

  alias Companies.Accounts

  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{
      email: auth.info.email,
      nickname: auth.info.nickname,
      token: auth.credentials.token,
      name: auth.info.name,
      image: auth.info.image,
      description: auth.info.description,
      bio: auth.extra.raw_info.user["bio"],
      location: auth.info.location
    }

    signin(conn, user_params)
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: Routes.company_path(conn, :recent, locale(conn)))
  end

  defp signin(conn, user_params) do
    case Accounts.create(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome!")
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.company_path(conn, :recent, "en"))

      {:error, reason} ->
        conn
        |> put_flash(:error, "Error: #{reason}")
        |> redirect(to: Routes.company_path(conn, :recent, "en"))
    end
  end
end
