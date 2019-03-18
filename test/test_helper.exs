ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Companies.Repo, :auto)
{:ok, _} = Application.ensure_all_started(:ex_machina)
Application.ensure_all_started(:bypass)

defmodule Companies.TestHelper do
  @session Plug.Session.init(
             store: :cookie,
             key: "_app",
             encryption_salt: "yadayada",
             signing_salt: "yadayada"
           )

  def with_session(conn) do
    conn
    |> Map.put(:secret_key_base, String.duplicate("abcdefgh", 8))
    |> Plug.Session.call(@session)
    |> Plug.Conn.fetch_session()
  end
end
