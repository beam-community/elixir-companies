defmodule Companies.Industries do
  @moduledoc """
  The Industries context.

  Pulled from the Global Industry Classification Standard (GICS)
  https://www.msci.com/our-solutions/indexes/gics
  """

  @industries [
    "Communication Services",
    "Consumer Discretionary",
    "Consumer Staples",
    "Education",
    "Energy",
    "Financials",
    "Health Care",
    "Industrials",
    "Information Technology",
    "Materials",
    "Real Estate",
    "Transportation",
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

  def for_select do
    []
  end
end
