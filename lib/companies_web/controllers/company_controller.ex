defmodule CompaniesWeb.CompanyController do
  use CompaniesWeb, :controller

  alias Companies.{Companies, Industries, Schema.Company}
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

  def new(conn, _params) do
    changeset = Companies.change(%Company{})
    industries = Industries.all()

    render(conn, "new.html", changeset: changeset, industries: industries)
  end

  def create(conn, %{"company" => params}) do
    case Companies.create(params, current_user(conn)) do
      {:ok, _company} ->
        conn
        |> put_flash(:info, "Thank you! Your change will be reviewed and should be available on the site shortly.")
        |> redirect(to: Routes.company_path(conn, :recent, locale(conn)))

      {:error, %Ecto.Changeset{} = changeset} ->
        industries = Industries.all()
        render(conn, "new.html", changeset: changeset, industries: industries)
    end
  end

  def show(conn, %{"id" => id}) do
    company = Companies.get!(id, preloads: [:jobs, :industry])
    :telemetry.execute(telemetry_event(), %{company_show: 1})
    render(conn, "show.html", company: company)
  end

  def edit(conn, %{"id" => id}) do
    company = Companies.get!(id)
    changeset = Companies.change(company)
    industries = Industries.all()
    render(conn, "edit.html", company: company, changeset: changeset, industries: industries)
  end

  def update(conn, %{"id" => id, "company" => company_params}) do
    company = Companies.get!(id)

    case Companies.update(company, company_params, current_user(conn)) do
      {:ok, _company} ->
        conn
        |> put_flash(:info, "Thank you. Your requested changes are pending approval.")
        |> redirect(to: Routes.company_path(conn, :recent, locale(conn)))

      {:error, %Ecto.Changeset{} = changeset} ->
        industries = Industries.all()
        render(conn, "edit.html", company: company, changeset: changeset, industries: industries)
    end
  end

  def delete(conn, %{"id" => id}) do
    company = Companies.get!(id)
    {:ok, _company} = Companies.delete(company, current_user(conn))

    conn
    |> put_flash(:info, "Thank you. Your delete request is pending approval.")
    |> redirect(to: Routes.company_path(conn, :recent, locale(conn)))
  end
end
