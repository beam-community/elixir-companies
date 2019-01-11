defmodule CompaniesWeb.JobView do
  use CompaniesWeb, :view

  def companies_for_select(companies) do
    Enum.map(companies, fn company ->
      {company.name, company.id}
    end)
  end
end
