defmodule CompaniesWeb.CompanyController do
  use CompaniesWeb, :controller

  alias Companies.{Companies, Industries, Schema.Company}

  def recent(conn, _params) do
    companies_count = Companies.count()
    recent_companies = Companies.all()

    render(conn, "recent.html", recent_companies: recent_companies, companies_count: companies_count)
  end

  def index(conn, params) do
    companies = Companies.all(params)

    render(conn, "index.html", companies: companies)
  end

  def new(conn, _params) do
    changeset = Companies.change_company(%Company{})
    industries = Industries.all()

    render(conn, "new.html", changeset: changeset, industries: industries)
  end

  def create(conn, %{"company" => params}) do
    case Companies.create(params, current_user(conn)) do
      {:ok, _company} ->
        conn
        |> put_flash(:info, "Company created successfully.")
        |> redirect(to: Routes.company_path(conn, :recent))

      {:error, %Ecto.Changeset{} = changeset} ->
        industries = Industries.all()
        render(conn, "new.html", changeset: changeset, industries: industries)
    end
  end

  def show(conn, %{"id" => id}) do
    company = Companies.get_company!(id)
    render(conn, "show.html", company: company)
  end

  def edit(conn, %{"id" => id}) do
    company = Companies.get_company!(id)
    changeset = Companies.change_company(company)
    industries = Industries.all()
    render(conn, "edit.html", company: company, changeset: changeset, industries: industries)
  end

  def update(conn, %{"id" => id, "company" => company_params}) do
    company = Companies.get_company!(id)

    case Companies.update_company(company, company_params, current_user(conn)) do
      {:ok, _company} ->
        conn
        |> put_flash(:info, "Company updated successfully.")
        |> redirect(to: Routes.company_path(conn, :recent))

      {:error, %Ecto.Changeset{} = changeset} ->
        industries = Industries.all()
        render(conn, "edit.html", company: company, changeset: changeset, industries: industries)
    end
  end

  def delete(conn, %{"id" => id}) do
    company = Companies.get_company!(id)
    {:ok, _company} = Companies.delete_company(company, current_user(conn))

    conn
    |> put_flash(:info, "Company deleted successfully.")
    |> redirect(to: Routes.company_path(conn, :recent))
  end
end
