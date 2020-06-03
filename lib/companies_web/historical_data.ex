defmodule CompaniesWeb.HistoricalData do
  @moduledoc """
  Single source of truth to gather all individual modules that provide historical
  data to live dashboard and merge their seperate history maps into one. If adding
  a new source of metric history for LiveDashboard, it only needs to implement
  it's own signatures/0 method as the other modules here do, and be added the the
  list of signatures below.
  """
  alias CompaniesWeb.{RepoMetricsHistory, VMHistory, ViewingStats}

  def signatures do
    for module <- [RepoMetricsHistory, VMHistory, ViewingStats], reduce: %{} do
      acc -> Map.merge(acc, apply(module, :signatures, []))
    end
  end
end
