defmodule CompaniesWeb.CompanyLiveView do
  use Phoenix.LiveView

  @page_size Application.get_env(:companies, :companies_per_page)

  def mount(session, socket) do
    socket =
      socket
      |> assign(page: 1, per_page: @page_size)
      |> assign(companies: session.companies)
      |> assign(industries: session.industries)
      |> assign(current_user: session.current_user)
      |> assign(search: session.search)

    {:ok, socket, temporary_assigns: [:companies]}
  end

  defp fetch(%{assigns: %{page: page, per_page: per_page, search: search}} = socket) do
    assign(socket, companies: Companies.search(search, page, per_page))
  end

  def handle_event("searchchange", %{"search" => search}, socket) do
    socket =
      socket
      |> assign(page: 1, per_page: @page_size, search: search)
      |> fetch()

    {:noreply, socket}
  end

  def handle_event("load-more", _, %{assigns: assigns} = socket) do
    {:noreply, socket |> assign(page: assigns.page + 1) |> fetch()}
  end

  def render(assigns) do
    Phoenix.View.render(CompaniesWeb.LiveView, "companies.html", assigns)
  end
end
