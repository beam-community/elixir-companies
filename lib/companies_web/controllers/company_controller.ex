defmodule CompaniesWeb.CompanyController do
  use CompaniesWeb, :controller

  alias Companies.{Companies, Industries}
  import CompaniesWeb.ViewingStats, only: [telemetry_event: 0]

  def recent(conn, _params) do
    companies_count = Companies.count()
    recent_companies = Companies.recent()

    render(conn, "recent.html", recent_companies: recent_companies, companies_count: companies_count)
  end

  def index(conn, params) do
    companies = Companies.all(params)
    industries = Industries.for_select()
    :telemetry.execute(telemetry_event(), %{company_index: 1})

    render(conn, "index.html", companies: companies, industries: industries)
  end

  def show(conn, %{"id" => id}) do
    company = Companies.get!(id, preloads: [:jobs, :industry])
    :telemetry.execute(telemetry_event(), %{company_show: 1})
    render(conn, "show.html", company: company)
  end
end
