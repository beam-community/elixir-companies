defmodule ElixirCompaniesWeb.LayoutView do
  use ElixirCompaniesWeb, :view

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
end
