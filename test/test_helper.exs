ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Companies.Repo, :auto)
{:ok, _} = Application.ensure_all_started(:ex_machina)
