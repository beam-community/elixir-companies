defmodule CompaniesWeb.CompanyController do
  use CompaniesWeb, :controller

  alias Companies.{Companies, Industries, Schema.Company}

  def recent(conn, _params) do
    companies_count = Companies.count_total()
    recent_companies = Companies.list_recent_companies()

    render(conn, "recent.html",
      recent_companies: recent_companies,
      companies_count: companies_count
    )
  end

  def hiring(conn, _params) do
    hiring_companies = Companies.list_hiring_companies()
    render(conn, "hiring.html", hiring_companies: hiring_companies)
  end

  def index(conn, _params) do
    companies = Companies.list_companies()
    render(conn, "index.html", companies: companies)
  end

  def new(conn, _params) do
    changeset = Companies.change_company(%Company{})
    industries = Industries.list_industries()
    render(conn, "new.html", changeset: changeset, industries: industries)
  end

  def create(conn, %{"company" => params}) do
    case Companies.create(params, current_user(conn)) do
      :ok ->
        conn
        |> put_flash(:info, "Company created successfully.")
        |> redirect(to: Routes.company_path(conn, :show, company))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    company = Companies.get_company!(id)
    render(conn, "show.html", company: company)
  end

  def edit(conn, %{"id" => id}) do
    company = Companies.get_company!(id)
    changeset = Companies.change_company(company)
    render(conn, "edit.html", company: company, changeset: changeset)
  end

  def update(conn, %{"id" => id, "company" => company_params}) do
    company = Companies.get_company!(id)

    case Companies.update_company(company, company_params) do
      {:ok, company} ->
        conn
        |> put_flash(:info, "Company updated successfully.")
        |> redirect(to: Routes.company_path(conn, :show, company))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", company: company, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    company = Companies.get_company!(id)
    {:ok, _company} = Companies.delete_company(company)

    conn
    |> put_flash(:info, "Company deleted successfully.")
    |> redirect(to: Routes.company_path(conn, :index))
  end
end
