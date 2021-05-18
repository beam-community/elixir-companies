defmodule CompaniesWeb.CompanyController do
  use CompaniesWeb, :controller

  alias Companies.Companies

  def show(conn, %{"id" => id_or_slug}) do
    with %{slug: slug} <- Companies.get_by_legacy_id(id_or_slug) do
      conn
      |> redirect(to: Routes.company_path(conn, :index, current_locale(), slug))
      |> halt()
    end

    render(conn, "show.html", company: Companies.get!(id_or_slug))
  end

  def current_locale do
    Gettext.get_locale(CompaniesWeb.Gettext)
  end
end
