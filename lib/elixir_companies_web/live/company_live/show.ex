defmodule ElixirCompaniesWeb.CompanyLive.Show do
  use ElixirCompaniesWeb, :live_view
  alias ElixirCompanies.Companies

  def handle_params(params, _, socket) do
    company = Companies.get!(params["name"])
    {:noreply, assign(socket, company: company)}
  end

  def hiring?(_), do: false

  def hiring_ribbon(company), do: if(hiring?(company), do: "has-ribbon", else: "")

  def industry_name(%{industry: industry}), do: industry

  def link_title(url) do
    Regex.replace(~r/(http:\/\/|https:\/\/|www.)/i, url, "")
  end

  def render("website.html", %{website: nil}), do: ""
  def render("blog.html", %{blog: nil}), do: ""
  def render("github.html", %{github: nil}), do: ""
  def render("location.html", %{location: nil}), do: ""

  def select_industries(industries) do
    Enum.map(industries, fn %{id: id, name: name} -> {name, id} end)
  end

  def markdown_format(markdown) do
    markdown
    |> Earmark.as_html!()
    |> Phoenix.HTML.raw()
  end
end
