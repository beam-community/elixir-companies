defmodule CompaniesWeb.CompanyLive do
  use Phoenix.LiveView

  def render(assigns) do
    CompaniesWeb.CompanyView.render("live_browse_companies.html", assigns)
  end

  def mount(%{companies: companies}, socket) do
    {:ok, assign(socket, companies: companies)}
  end
end
