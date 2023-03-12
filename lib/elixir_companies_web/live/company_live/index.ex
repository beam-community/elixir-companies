defmodule ElixirCompaniesWeb.CompanyLive.Index do
  @moduledoc false

  use ElixirCompaniesWeb, :live_view

  alias ElixirCompanies.Companies
  alias ElixirCompanies.Industries

  def mount(params, session, socket) do
    industries = Industries.all()

    socket =
      socket
      |> assign(industries: industries, locale: session["locale"], text: "", selected_industry: "")
      |> search(params)

    {:ok, socket, temporary_assigns: [companies: nil]}
  end

  def handle_event("search", params, %{assigns: _assigns} = socket) do
    socket =
      socket
      |> search(params)

    {:noreply, socket}
  end

  def handle_event("load_more", _, %{assigns: assigns} = socket) do
    page = assigns.page + 1

    if last_page?(assigns) do
      {:noreply, socket}
    else
      %{entries: entries} = Companies.all(%{"page" => "#{page}"})

      {:noreply,
       socket
       |> assign(companies: entries)
       |> assign(page: page)
       |> assign(update: "append")}
    end
  end

  defp search(socket, params) do
    results = Companies.all(params)

    socket
    |> assign(
      companies: results.entries,
      page: 1,
      text: params["search"]["text"],
      selected_industry: params["search"]["industry"],
      total_pages: results.total_pages,
      update: "replace"
    )
  end

  defp last_page?(assigns), do: assigns.page >= assigns.total_pages

  def selected_industry_text(industry, industry), do: "selected"
  def selected_industry_text(_, _), do: ""
end
