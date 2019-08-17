defmodule CompaniesWeb.CompanyLiveView do
  use Phoenix.LiveView

  def mount(session, socket) do
    IO.inspect session
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
    companies = Companies.search(search_params)

    socket =
      socket
      |> assign(companies: companies)

    {:noreply, socket}
  end

  def render(assigns) do
    CompaniesWeb.LiveView.render("browse.html", assigns)
  end
end
