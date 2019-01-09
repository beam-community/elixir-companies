defmodule CompaniesWeb.LayoutView do
  use CompaniesWeb, :view

  def divide_industries_in_columns([]), do: []

  def divide_industries_in_columns(industries) do
    industries_length = length(industries)

    rows =
      case rem(industries_length, 3) do
        0 -> div(industries_length, 3)
        _ -> div(industries_length, 3) + 1
      end

    Enum.chunk_every(industries, rows)
  end

  def signed_in?(conn) do
    with %{id: _id} <- Map.get(conn.assigns, :current_user) do
      true
    else
      _ -> false
    end
  end
end
