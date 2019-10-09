defmodule CompaniesWeb.CompanyView do
  use CompaniesWeb, :view

  import Scrivener.HTML

  def hiring?(%{jobs: jobs}), do: length(jobs) > 0

  def hiring_ribbon(company), do: if(hiring?(company), do: "has-ribbon", else: "")

  def industry_name(%{industry: %{name: industry_name}}), do: industry_name

  def link_title(url) do
    Regex.replace(~r/(http:\/\/|https:\/\/|www.)/i, url, "")
  end

  def url_with_scheme("http://" <> _ = url), do: url
  def url_with_scheme("https://" <> _ = url), do: url
  def url_with_scheme(url, scheme \\ "https"), do: "#{scheme}://#{url}"

  def render("url.html", %{url: nil}), do: ""
  def render("blog.html", %{blog: nil}), do: ""
  def render("github.html", %{github: nil}), do: ""
  def render("location.html", %{location: nil}), do: ""

  def select_industries(industries) do
    Enum.map(industries, fn %{id: id, name: name} -> {name, id} end)
  end

  def markdown_format(markdown) do
    markdown
    |> Earmark.as_html!()
    |> HtmlSanitizeEx.markdown_html()
    |> Phoenix.HTML.raw()
  end
end
