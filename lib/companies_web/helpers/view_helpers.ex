defmodule CompaniesWeb.ViewHelpers do
  def hiring?(%{jobs: jobs}), do: length(jobs) > 0

  def hiring_ribbon(company), do: if(hiring?(company), do: "has-ribbon", else: "")

  def industry_name(%{industry: %{name: industry_name}}), do: industry_name

  def link_title(url) do
    url
    |> String.replace("http://", "")
    |> String.replace("https://", "")
    |> String.replace("www.", "")
  end

  def select_industries(industries) do
    Enum.map(industries, fn %{id: id, name: name} -> {name, id} end)
  end

  def selected_text(%{}, _), do: ""
  def selected_text(%{search: %{}}, _), do: ""

  def selected?(%{search: %{"industry_id" => iid}}, industry_id) do
    if iid == industry_id do
      "selected"
    end
  end

  def url_with_scheme("http://" <> _ = url), do: url
  def url_with_scheme("https://" <> _ = url), do: url
  def url_with_scheme(url, scheme \\ "https"), do: "#{scheme}://#{url}"
end
