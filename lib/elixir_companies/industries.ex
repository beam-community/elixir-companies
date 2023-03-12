defmodule ElixirCompanies.Industries do
  @moduledoc """
  The Industries context.

  Derived from the 11 sectors of the Stock Market
  https://www.nasdaq.com/articles/the-11-sectors-of-the-stock-market-their-biggest-etfs-2021-05-30
  """

  @industries [
    "Communication Services",
    "Consumer Discretionary",
    "Consumer Staples",
    "Energy",
    "Financials",
    "Health Care",
    "Industrials",
    "Materials",
    "Real Estate",
    "Technology",
    "Utilities"
  ]

  @doc """
  Returns the list of industries.

  ## Examples

  iex> all()
  [%Industry{}, ...]

  """
  def all do
    @industries
  end
end
