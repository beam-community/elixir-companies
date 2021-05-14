defmodule CompaniesWeb.PageLive do
  @moduledoc false
  use CompaniesWeb, :live_view

  alias Companies.{Companies, Testimonials}

  @ten_seconds 5_000

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:companies, Companies.random(12))
      |> assign(:testimonial, Testimonials.random())
      |> assign(:count, Companies.count())

    if connected?(socket), do: Process.send_after(self(), :update, @ten_seconds)

    {:ok, socket}
  end

  @impl true
  def handle_info(:update, socket) do
    Process.send_after(self(), :update, @ten_seconds)
    [addition] = Companies.random()
    companies = Enum.slice([addition | socket.assigns.companies], 0..11)
    {:noreply, assign(socket, companies: companies, testimonial: Testimonials.random())}
  end
end
