defmodule CompaniesWeb.CompanyLiveView do
  use Phoenix.LiveView

  @page_size Application.get_env(:companies, :companies_per_page)

  def mount(_session, socket) do
    {:ok, assign(socket, page: 1, per_page: @page_size)}
  end

  def handle_params(params, _url, socket) do
    {page, ""} = Integer.parse(params["page"] || "1")
    {:noreply, socket |> assign(page: page) |> fetch()}
  end

  defp fetch(socket) do
    %{page: page, per_page: per_page} = socket.assigns
    companies = Companies.search(socket.assigns.search, page: page, per_page: per_page)
    industries = Industries.for_select()
    search = %{
      industry_id: nil,
      text: "",
      only_hiring: false
    }
    current_user = CompaniesWeb.UserHelpers.current_user(socket)
    assign(socket, companies: companies)
  end

  def handle_info({Companies, [:company | _], _}, socket) do
    {:noreply, fetch(socket)}
  end

  def handle_event("searchchange", %{"search" => search_params}, socket) do
    {:noreply, assign(socket, :companies, Companies.search(search_params))}
  end

  def handle_event("keydown", %{"code" => "ArrowLeft"}, socket) do
    {:noreply, go_page(socket, socket.assigns.page - 1)}
  end
  def handle_event("keydown", %{"code" => "ArrowRight"}, socket) do
    {:noreply, go_page(socket, socket.assigns.page + 1)}
  end
  def handle_event("keydown", _, socket), do: {:noreply, socket}

  defp go_page(socket, page) when page > 0 do
    live_redirect(socket, to: Routes.live_path(socket, __MODULE__, page))
  end
  defp go_page(socket, page), do: socket

  def render(assigns) do
    Phoenix.View.render(CompaniesWeb.LiveView, "companies.html", assigns)
  end
end
