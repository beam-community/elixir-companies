defmodule Companies.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      CompaniesWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Companies.PubSub},
      # Start the endpoint when the application starts
      CompaniesWeb.Endpoint,
      {Task.Supervisor, name: Companies.TaskSupervisor},
      CompaniesWeb.ViewingStats
    ]

    CompaniesWeb.ViewingStats.setup_handlers()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Companies.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CompaniesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
