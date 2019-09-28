defmodule CompaniesWeb.JobLiveView do
  use Phoenix.LiveView

  alias Companies.Jobs

  def mount(session, socket) do
    socket =
      case socket.assigns do
        %{} ->
          assign(
            socket,
            %{
              jobs: session.jobs,
              current_user: session.current_user,
              search: session.search
            }
          )

        _ ->
          socket
      end

    {:ok, socket}
  end

  def handle_event("searchchange", %{"search" => search_params}, socket) do
    {:noreply, assign(socket, :jobs, Jobs.search(search_params))}
  end

  def render(assigns) do
    Phoenix.View.render(CompaniesWeb.LiveView, "jobs.html", assigns)
  end
end
