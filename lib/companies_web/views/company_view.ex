defmodule CompaniesWeb.CompanyView do
  use CompaniesWeb, :view

  import Scrivener.HTML
  import CompaniesWeb.ViewHelpers

  def render("url.html", %{url: nil}), do: ""
  def render("blog.html", %{blog: nil}), do: ""
  def render("github.html", %{github: nil}), do: ""
  def render("location.html", %{location: nil}), do: ""
end
