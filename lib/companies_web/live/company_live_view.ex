defmodule CompaniesWeb.CompanyLiveView do
  use Phoenix.LiveView

  @page_size Application.get_env(:companies, :companies_per_page)

  def mount(session, socket) do
    socket =
      case socket.assigns do
        %{} ->
          assign(
            socket,
            %{
              companies: session.companies,
              industries: session.industries,
              current_user: session.current_user,
              search: session.search
            }
          )

        _ ->
          socket
      end

    {:ok, socket}
  end

  def handle_event("searchchange", %{"search" => search_params}, socket) do
    {:noreply, assign(socket, :companies, Companies.search(search_params))}
  end

  def render(assigns) do
    Phoenix.View.render(CompaniesWeb.LiveView, "companies.html", assigns)
  end
end
