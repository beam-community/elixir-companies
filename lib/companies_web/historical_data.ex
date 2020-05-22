defmodule CompaniesWeb.HistoricalData do
  alias CompaniesWeb.{RepoMetricsHistory, ViewingStats}

  def signatures do
    for module <- [RepoMetricsHistory, ViewingStats], reduce: %{} do
      acc -> Map.merge(acc, apply(module, :signatures, []))
    end
  end
end
