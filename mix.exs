defmodule Companies.MixProject do
  use Mix.Project

  def project do
    [
      app: :companies,
      version: "0.1.0",
      elixir: "~> 1.17",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.html": :test],
      aliases: aliases(),
      deps: deps(),
      releases: releases(),
      dialyzer: [
        plt_add_apps: [:mix, :ex_unit]
      ]
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

  def releases do
    [
      companies: [
        include_executables_for: [:unix],
        cookie: "elixir-companies"
      ]
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
      {:appsignal_phoenix, "~> 2.0"},
      {:earmark, "~> 1.4"},
      {:gettext, "~> 0.22"},
      {:html_sanitize_ex, "~> 1.4"},
      {:httpoison, "~> 2.0"},
      {:jason, "~> 1.1"},
      {:libcluster, "~> 3.3"},
      {:live_dashboard_history, "~> 0.1"},
      {:nimble_publisher, "~> 0.1.3"},
      {:phoenix, "~> 1.6"},
      {:phoenix_html, "~> 3.2", override: true},
      {:phoenix_live_view, "~> 0.18"},
      {:phoenix_pubsub, "~> 2.1"},
      {:phoenix_view, "~> 2.0"},
      {:plug_cowboy, "~> 2.6"},
      {:set_locale, "~> 0.2"},
      {:slugify, "~> 1.3.1"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:timex, "~> 3.6.1"},

      # Dev & Test
      {:credo, "~> 1.7.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:esbuild, "~> 0.2", runtime: Mix.env() == :dev},
      {:excoveralls, "~> 0.12", only: :test},
      {:floki, ">= 0.0.0", only: :test},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:dart_sass, "~> 0.5", runtime: Mix.env() == :dev},
      {:parallel_stream, "~> 1.1", only: [:dev, :test]}
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
      setup: ["deps.get", "cmd --cd assets npm install"],
      test: [
        "format --check-formatted --dry-run",
        "compile --warnings-as-errors",
        "test"
      ],
      checks: ["format", "credo", "dialyzer"],
      "assets.deploy": [
        "esbuild default --minify",
        "sass default --no-source-map --style=compressed",
        "phx.digest"
      ]
    ]
  end
end
