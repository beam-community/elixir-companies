defmodule ElixirCompaniesWeb.CompanyLive.Index do
  @moduledoc false

  use ElixirCompaniesWeb, :live_view

  alias ElixirCompanies.Companies
  alias ElixirCompanies.Industries

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    industries = Industries.all()

    socket =
      assign(socket,
        industries: industries,
        locale: session["locale"],
        text: "",
        selected_industry: "",
        page: 1,
        update: "append"
      )

    {:ok, get_companies(socket), temporary_assigns: [companies: []]}
  end

  @impl Phoenix.LiveView
  def handle_event("search", params, %{assigns: _assigns} = socket) do
    text = params["search"]["text"]
    selected_industry = params["search"]["industry"]

    socket =
      assign(socket,
        page: 1,
        text: text,
        selected_industry: selected_industry,
        update: "replace"
      )

    {:noreply, get_companies(socket)}
  end

  def handle_event("load_more", _, %{assigns: assigns} = socket) do
    if last_page?(assigns) do
      {:noreply, socket}
    else
      socket = assign(socket, page: socket.assigns.page + 1, update: "append")

      {:noreply, get_companies(socket)}
    end
  end

  defp get_companies(socket) do
    params = %{
      page: socket.assigns.page,
      text: socket.assigns.text,
      industry: socket.assigns.selected_industry
    }

    %{entries: companies, total_pages: total_pages} = Companies.all(params)

    assign(socket, companies: companies, total_pages: total_pages)
  end

  defp last_page?(assigns), do: assigns.page >= assigns.total_pages

  defp selected_industry_text(selected_industry, industry), do: selected_industry == industry
end
