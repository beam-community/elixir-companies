defmodule Companies.MixProject do
  use Mix.Project

  def project do
    [
      app: :companies,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.html": :test],
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Companies.Application, []},
      extra_applications: [:appsignal, :logger, :runtime_tools, :os_mon]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:appsignal, "~> 1.13"},
      {:bamboo, "~> 1.4"},
      {:ecto_sql, "~> 3.4"},
      {:gettext, "~> 0.17"},
      {:html_sanitize_ex, "~> 1.4.0"},
      {:httpoison, "~> 1.6"},
      {:jason, "~> 1.1"},
      {:phoenix, "~> 1.5.1", override: true},
      {:phoenix_ecto, "~> 4.1"},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_live_dashboard, "~> 0.2"},
      {:phoenix_pubsub, "~> 2.0"},
      {:plug_cowboy, "~> 2.2"},
      {:postgrex, ">= 0.0.0"},
      {:scrivener_ecto, "~> 2.3"},
      {:scrivener_html, "~> 1.8"},
      {:set_locale, "~> 0.2.8"},
      {:timex, "~> 3.6.1"},
      {:ueberauth, "~> 0.6.3"},
      {:ueberauth_github, "~> 0.8.0"},
      {:bypass, "~> 1.0", only: :test},
      {:ex_machina, "~> 2.4", only: :test},
      {:excoveralls, "~> 0.12", only: :test},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:earmark, "~> 1.4"},
      {:credo, "~> 1.4.0", only: [:dev, :test], runtime: false},
      {:telemetry_poller, "~> 0.4"},
      {:telemetry_metrics, "~> 0.4"},

      # Live view
      {:phoenix_live_view, "~> 0.12"},
      {:floki, ">= 0.0.0", only: :test}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: [
        "format --check-formatted --check-equivalent --dry-run",
        "compile --warnings-as-errors",
        "ecto.drop --quiet",
        "ecto.create --quiet",
        "ecto.migrate --quiet",
        "test"
      ]
    ]
  end
end
