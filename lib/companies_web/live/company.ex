defmodule CompaniesWeb.CompanyLive do
  @moduledoc false
  use Phoenix.LiveView, layout: {CompaniesWeb.LayoutView, :live}

  alias CompaniesWeb.CompanyView
  alias Companies.{Companies, Industries}

  alias CompaniesWeb.Router.Helpers, as: Routes

  def render(assigns) do
    Phoenix.View.render(CompanyView, "index.html", assigns)
  end

  def mount(params, _session, socket) do
    industries = Industries.for_select()

    socket =
      socket
      |> assign(
        industries: industries,
        locale: params["locale"]
      )
      |> search(params)

    {:ok, socket, temporary_assigns: [companies: []]}
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

  def handle_event("load_more", _, %{assigns: assigns} = socket) do
    page = assigns.page + 1

    if last_page?(assigns) do
      {:noreply, socket}
    else
      companies = Companies.all(%{"page" => page})

      {:noreply,
       socket
       |> assign(companies: companies)
       |> assign(page: page)
       |> assign(update: "append")
       |> push_patch(to: Routes.live_path(socket, CompaniesWeb.CompanyLive, assigns.locale))}
    end
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

  defp last_page?(assigns) do
    assigns.page >= assigns.total_pages
  end
end
