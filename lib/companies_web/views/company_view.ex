defmodule CompaniesWeb.CompanyView do
  use CompaniesWeb, :view

  def hiring?(%{jobs: jobs}), do: length(jobs) > 0

  def hiring_ribbon(company), do: if(hiring?(company), do: "has-ribbon", else: "")

  def industry_name(company) do
    case company.industry do
      nil -> ""
      industry -> industry.name
    end
  end

  def link_title(url) do
    url
    |> String.replace("http://", "")
    |> String.replace("https://", "")
    |> String.replace("www.", "")
  end

  def render("url.html", %{url: nil}), do: ""
  # def render("url.html", %{url: url}) do
  #   render "url.html", url: url
  # end
  def render("blog.html", %{blog: nil}), do: ""
  def render("github.html", %{github: nil}), do: ""
  def render("location.html", %{location: nil}), do: ""

  def select_industries(industries) do
    Enum.map(industries, fn %{id: id, name: name} -> {name, id} end)
  end
end
