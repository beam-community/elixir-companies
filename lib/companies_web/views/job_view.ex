defmodule CompaniesWeb.JobView do
  use CompaniesWeb, :view

  import Scrivener.HTML

  def companies_for_select(companies) do
    Enum.map(companies, fn company ->
      {company.name, company.id}
    end)
  end

  @doc """
  Returns the Bulma input class based on the field and field error
  """
  def input_class(changeset, param) do
    if changeset.errors[param] != nil && changeset.action == :create do
      "input is-danger"
    else
      "input"
    end
  end

  def relative_time(%{updated_at: time}) do
    Timex.format!(time, "{relative}", :relative)
  end

  def remote_ribbon(%{remote: true}), do: "has-ribbon"
  def remote_ribbon(_), do: ""

  def url_with_scheme("http://" <> _ = url), do: url
  def url_with_scheme("https://" <> _ = url), do: url
  def url_with_scheme(url, scheme \\ "https"), do: "#{scheme}://#{url}"
end
