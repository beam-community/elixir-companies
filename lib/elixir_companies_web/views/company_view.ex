defmodule ElixirCompaniesWeb.CompanyView do
  use ElixirCompaniesWeb, :view

  def hiring_ribbon(company) do
    case hiring?(company) do
      true -> "has-ribbon"
      false -> ""
    end
  end

  def hiring?(company) do
    case company.jobs do
      [] -> false
      _ -> true
    end
  end

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
end
