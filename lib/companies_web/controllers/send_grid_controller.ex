defmodule CompaniesWeb.SendGridController do
  use CompaniesWeb, :controller

  alias Companies.EmailEvents

  plug :authenticate

  def create(conn, %{"_json" => events}) do
    EmailEvents.create(events)
    send_resp(conn, 200, "")
  end

  defp authenticate(%{params: params} = conn, _opts) do
    if Map.get(params, "key") == System.get_env("SENDGRID_WEBHOOK_KEY") do
      conn
    else
      conn
      |> send_resp(403, "Go no further")
      |> halt()
    end
  end
end
