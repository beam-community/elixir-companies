defmodule CompaniesWeb.CompanyView do
  use CompaniesWeb, :view

  import Companies.URLSchemer

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

  def markdown_format(markdown) do
    markdown
  end

  def selected(_, ""), do: ""
  def selected(_, nil), do: ""
  def selected(industry, industry), do: "selected"
  def selected(_industry, _selection), do: ""
end
