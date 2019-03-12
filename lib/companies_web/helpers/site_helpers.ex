defmodule CompaniesWeb.SiteHelpers do
  @moduledoc false

  import CompaniesWeb.Gettext

  def query_params(%{query_params: %{"type" => type}}), do: [type: type]
  def query_params(_), do: []

  def maintainers, do: Map.get(site_data(), :maintainers)

  def site_description, do: gettext("A collection of companies using Elixir in production.")

  def site_title, do: Map.get(site_data(), :name)

  defp site_data, do: Application.get_env(:companies, :site_data)
end
