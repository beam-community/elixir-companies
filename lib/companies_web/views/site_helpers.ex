defmodule CompaniesWeb.SiteHelpers do
  @moduledoc false

  alias Companies.Industries

  def industry_groupings, do: divide_industries_in_columns(Industries.list_available_industries())

  def maintainers, do: Map.get(site_data(), :maintainers)

  def site_description, do: Map.get(site_data(), :description)

  def site_title, do: Map.get(site_data(), :name)

  defp divide_industries_in_columns([]), do: []

  defp divide_industries_in_columns(industries) do
    industries_length = length(industries)

    rows =
      case rem(industries_length, 3) do
        0 -> div(industries_length, 3)
        _ -> div(industries_length, 3) + 1
      end

    Enum.chunk_every(industries, rows)
  end

  defp site_data, do: Application.get_env(:companies, :site_data)
end
