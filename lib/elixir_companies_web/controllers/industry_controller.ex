defmodule CompaniesWeb.IndustryController do
  use CompaniesWeb, :controller

  alias Companies.Industries
  alias Companies.Industries.Industry

  def index(conn, _params) do
    industries = Industries.list_industries()
    render(conn, "index.html", industries: industries)
  end

  def new(conn, _params) do
    changeset = Industries.change_industry(%Industry{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"industry" => industry_params}) do
    case Industries.create_industry(industry_params) do
      {:ok, industry} ->
        conn
        |> put_flash(:info, "Industry created successfully.")
        |> redirect(to: Routes.industry_path(conn, :show, industry))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    industry = Industries.get_industry_with_companies!(id)
    render(conn, "show.html", industry: industry)
  end

  def edit(conn, %{"id" => id}) do
    industry = Industries.get_industry!(id)
    changeset = Industries.change_industry(industry)
    render(conn, "edit.html", industry: industry, changeset: changeset)
  end

  def update(conn, %{"id" => id, "industry" => industry_params}) do
    industry = Industries.get_industry!(id)

    case Industries.update_industry(industry, industry_params) do
      {:ok, industry} ->
        conn
        |> put_flash(:info, "Industry updated successfully.")
        |> redirect(to: Routes.industry_path(conn, :show, industry))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", industry: industry, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    industry = Industries.get_industry!(id)
    {:ok, _industry} = Industries.delete_industry(industry)

    conn
    |> put_flash(:info, "Industry deleted successfully.")
    |> redirect(to: Routes.industry_path(conn, :index))
  end
end
