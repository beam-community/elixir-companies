defmodule Companies.Repo.Migrations.AddSlugValueForExistingCompanies do
  use Ecto.Migration

  alias Companies.Repo
  alias Companies.Schema.Company

  def change do
    Repo.all(Company)
    |> Enum.map(fn company ->
      slug =
        company.name
        |> String.replace(~r/['’]s/u, "s")
        |> String.downcase()
        |> String.replace(~r/([^a-z0-9가-힣])+/, "-")
        |> String.replace(" ", "-")

      changeset = Company.changeset(company, %{"slug" => slug})
      changeset = unless changeset.valid?, do: Company.changeset(company, %{"slug" => "#{slug}-2"})

      Repo.update(changeset)
    end)
  end
end
