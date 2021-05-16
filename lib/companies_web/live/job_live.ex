defmodule CompaniesWeb.JobLive do
  @moduledoc false
  use CompaniesWeb, :live_view

  alias Companies.Companies

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :hiring, Companies.hiring())}
  end
end
