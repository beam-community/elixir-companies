defmodule CompaniesWeb.PageLive do
  @moduledoc false
  use CompaniesWeb, :live_view

  alias Companies.{Companies, Testimonials}

  @five_seconds 5_000

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:companies, Companies.random(12))
      |> assign(:testimonial, Testimonials.random())
      |> assign(:count, Companies.count())

    if connected?(socket) do
      Process.send_after(self(), :companies, @five_seconds)
    end

    {:ok, socket}
  end

  @impl true
  def handle_info(:companies, socket) do
    Process.send_after(self(), :companies, @five_seconds)
    {:noreply, assign_random_company(socket)}
  end

  defp assign_random_company(socket) do
    current = socket.assigns.companies
    [addition] = Companies.random()

    if addition in current, do: assign_random_company(socket)

    assign(socket, companies: Enum.slice([addition | socket.assigns.companies], 0..11))
  end
end
