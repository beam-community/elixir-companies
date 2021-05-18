defmodule CompaniesWeb.ForHireLive do
  @moduledoc false
  use CompaniesWeb, :live_view

  alias Companies.ForHires

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :for_hires, ForHires.all())}
  end
end
