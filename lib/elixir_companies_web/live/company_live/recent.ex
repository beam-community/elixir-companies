defmodule ElixirCompaniesWeb.CompanyLive.Recent do
  use ElixirCompaniesWeb, :live_view

  alias ElixirCompanies.Companies

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    companies_count = Companies.count()
    %{entries: recent_companies} = Companies.recent()

    socket =
      assign(
        socket,
        locale: session["locale"],
        recent_companies: recent_companies,
        companies_count: companies_count
      )

    {:ok, socket}
  end
end
