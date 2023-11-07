defmodule Companies.Helpers do
  @moduledoc """
  Helpers for working with our data sets
  """

  @default_page_size "16"

  def searched_list(list, params) do
    search_param = params["search"]["text"]

    if search_param do
      list
      |> Enum.filter(
        &(String.contains?(String.downcase(&1.name), String.downcase(search_param)) or
            String.contains?(String.downcase(&1.industry), String.downcase(search_param)))
      )
    else
      list
    end
  end

  def sorted_list(list, params) do
    params
    |> sorting_params()
    |> sort_by(list)
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

  defp sort_by({:last_changed_on, direction}, list), do: Enum.sort_by(list, & &1.last_changed_on, {direction, Date})
  defp sort_by({field, direction}, list), do: Enum.sort_by(list, &Map.get(&1, field), direction)

  defp sorting_params(params) do
    field = Map.get(params, "sort", "name")

    direction = sorting_direction(params)
    {String.to_existing_atom(field), direction}
  end

  defp sorting_direction(%{"order" => "desc"}), do: :desc
  defp sorting_direction(_params), do: :asc
end
