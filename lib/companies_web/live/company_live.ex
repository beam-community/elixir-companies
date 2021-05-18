defmodule CompaniesWeb.CompanyLive do
  use CompaniesWeb, :live_view

  alias Companies.Companies

  @page_size 20

  def mount(params, _session, socket) do
    page =
      params
      |> Map.get("page", "0")
      |> String.to_integer()

    companies =
      Companies.all()
      |> Enum.chunk(@page_size)
      |> Enum.at(page)

    socket =
      socket
      |> assign(:companies, companies)
      |> assign(:page, page)
      |> assign(:pages, length(Companies.all()))

    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def handle_event("search", params, %{assigns: assigns} = socket) do
    socket =
      socket
      |> search(params)
      |> push_patch(to: Routes.live_path(socket, CompaniesWeb.CompanyLive, assigns.locale, params))

    {:noreply, socket}
  end

  defp search(socket, params) do
    companies = Companies.all(params)

    socket
    |> assign(
      companies: companies,
      page: 1,
      total_pages: companies.total_pages,
      text: params["search"]["text"],
      industry_id: params["search"]["industry_id"],
      update: "replace"
    )
  end
end
