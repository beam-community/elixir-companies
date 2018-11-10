# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ElixirCompanies.Repo.insert!(%ElixirCompanies.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
File.cwd!()
|> Path.join("/priv/repo/industries.yml")
|> File.read!()
|> String.split("\n")
|> IO.inspect()
|> Enum.map(fn ind_name ->
  ElixirCompanies.Industries.create_industry(%{name: ind_name})
end)
