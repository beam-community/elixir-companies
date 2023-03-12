defmodule ElixirCompanies.Helpers do
  @moduledoc """
  Helpers for working with our data sets
  """

  @default_page_size "16"

  def searched_list(list, search_params) do
    Enum.reduce(search_params, list, fn
      {:industry, ""}, list ->
        list

      {:industry, searched_industry}, list ->
        Enum.filter(list, fn %{industry: industry} -> industry == searched_industry end)

      {:text, ""}, list ->
        list

      {:text, text}, list ->
        Enum.filter(list, fn company ->
          company
          |> company_values()
          |> Enum.any?(&in_modified_text?(&1, text))
        end)

      _, list ->
        list
    end)
  end

  def sorted_list(list, params) do
    {field, direction} = sorting_params(params)
    Enum.sort_by(list, &Map.get(&1, field), direction)
  end

  def paginated_list(list, params) do
    {page, size} = pagination_params(params)
    entries = Enum.slice(list, page * size - size, size)

    total_entries = length(list)
    total_pages = ceil(total_entries / size)

    %{entries: entries, page_number: page, page_size: size, total_entries: total_entries, total_pages: total_pages}
  end

  defp pagination_params(params) do
    page = Map.get(params, :page, 1)
    size = Map.get(params, :size, @default_page_size)

    {page, String.to_integer(size)}
  end

  defp sorting_params(params) do
    field = Map.get(params, "sort", "dated_added")
    direction = sorting_direction(params)
    {field, direction}
  end

  defp sorting_direction(%{"order" => "desc"}), do: :desc
  defp sorting_direction(_params), do: :asc

  defp company_values(%{name: name, description: description, location: %{city: city, state: state, country: country}}) do
    [name, description, city, state, country]
  end

  defp in_modified_text?(field, text) do
    text = String.downcase(text)
    field = String.downcase(field)

    String.contains?(field, text)
  end
end
