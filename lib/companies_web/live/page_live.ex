defmodule CompaniesWeb.PageLive do
  @moduledoc false
  use CompaniesWeb, :live_view

  alias Companies.Companies

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign_randoms(socket)}
  end

  def handle_event("shuffle", _value, socket) do
    {:noreply, assign_randoms(socket)}
  end

  defp assign_randoms(socket), do: assign(socket, :companies, Companies.random())
end
