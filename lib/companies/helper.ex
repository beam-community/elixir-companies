defmodule Companies.Helpers do
  def searched_list(list, _params) do
    list
  end

  def sorted_list(list, params) do
    {field, direction} = sorting_params(params)
    Enum.sort_by(list, &Map.get(&1, field), direction)
  end

  def paginated_list(list, params) do
    {page, size} = pagination_params(params)
    Enum.slice(list, (page * size) - size, size)
  end

  defp pagination_params(params) do
    page = Map.get(params, "page", "1")
    size = Map.get(params, "size", "50")

    {String.to_integer(page), String.to_integer(size)}
  end

  defp sorting_params(params) do
    field = Map.get(params, "sort", "dated_added")
    direction = sorting_direction(params)
    {field, direction}
  end

  defp sorting_direction(%{"order" => "desc"}), do: :desc
  defp sorting_direction(_params), do: :asc
end
