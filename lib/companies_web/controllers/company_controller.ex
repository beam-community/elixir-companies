defmodule CompaniesWeb.CompanyController do
  use CompaniesWeb, :controller

  alias Companies.{Companies, Industries, Schema.Company}

  def recent(conn, _params) do
    companies_count = Companies.count()
    recent_companies = Companies.recent()

    render(conn, "recent.html", recent_companies: recent_companies, companies_count: companies_count)
  end

  def index(conn, params) do
    companies = Companies.all(params)
    industries = Industries.for_select()

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

  def show(conn, %{"slug" => slug}) do
    company = Companies.get_by_slug!(slug, preloads: [:jobs, :industry])
    render(conn, "show.html", company: company)
  end

  def edit(conn, %{"slug" => slug}) do
    company = Companies.get_by_slug!(slug)
    changeset = Companies.change(company)
    industries = Industries.all()
    render(conn, "edit.html", company: company, changeset: changeset, industries: industries)
  end

  def update(conn, %{"slug" => slug, "company" => company_params}) do
    company = Companies.get_by_slug!(slug)

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

  def delete(conn, %{"slug" => slug}) do
    company = Companies.get_by_slug!(slug)
    {:ok, _company} = Companies.delete(company, current_user(conn))

    conn
    |> put_flash(:info, "Thank you. Your delete request is pending approval.")
    |> redirect(to: Routes.company_path(conn, :recent, locale(conn)))
  end
end
