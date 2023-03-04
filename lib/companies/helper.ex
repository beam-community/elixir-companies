defmodule Companies.Helpers do
  @moduledoc """
  Helpers for working with our data sets
  """

  @default_page_size "16"

  def searched_list(list, params) do
    {name, industry} = search_params(params)

    list
    |> filter_by_industry(industry)
    |> filter_by_name(name)
  end

  defp filter_by_industry(list, nil), do: list
  defp filter_by_industry(list, industry), do: Enum.filter(list, &(&1.industry == industry))

  defp filter_by_name(list, nil), do: list
  defp filter_by_name(list, pattern), do: Enum.filter(list, &Regex.match?(pattern, &1.name))

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
    page = Map.get(params, "page", "1")
    size = Map.get(params, "size", @default_page_size)

    {String.to_integer(page), String.to_integer(size)}
  end

  defp search_params(params) do
    search_params = Map.get(params, "search", %{})
    industry = Map.get(search_params, "industry", nil)

    text =
      search_params
      |> Map.get("text", "")
      |> String.trim()

    name =
      case Regex.compile(text, "i") do
        {:ok, ~r//} -> nil
        {:ok, regex} -> regex
        _ -> nil
      end

    {name, industry}
  end

  defp sorting_params(params) do
    field = Map.get(params, "sort", "dated_added")
    direction = sorting_direction(params)
    {field, direction}
  end

  defp sorting_direction(%{"order" => "desc"}), do: :desc
  defp sorting_direction(_params), do: :asc
end
