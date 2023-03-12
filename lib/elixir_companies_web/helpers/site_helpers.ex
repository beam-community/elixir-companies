defmodule ElixirCompaniesWeb.SiteHelpers do
  @moduledoc false

  import ElixirCompaniesWeb.Gettext

  def query_params(%{query_params: %{"type" => type}}), do: [type: type]
  def query_params(%{query_params: %{"approved" => approved}}), do: [approved: approved]
  def query_params(_), do: []

  def site_description, do: gettext("A collection of companies using Elixir in production.")

  def site_title, do: Map.get(site_data(), :name)

  defp site_data, do: Application.get_env(:companies, :site_data)
end
