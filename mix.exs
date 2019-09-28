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
      extra_applications: [:appsignal, :logger, :runtime_tools]
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
      {:appsignal, "~> 1.0"},
      {:ecto_sql, "~> 3.2"},
      {:gettext, "~> 0.17"},
      {:httpoison, "~> 1.5"},
      {:jason, "~> 1.1"},
      {:phoenix, "~> 1.4.10"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_html, "~> 2.13.3"},
      {:phoenix_pubsub, "~> 1.1.2"},
      {:plug_cowboy, "~> 2.1"},
      {:postgrex, ">= 0.15.1"},
      {:scrivener_ecto, "~> 2.2"},
      {:scrivener_html, "~> 1.8"},
      {:set_locale, "~> 0.2.7"},
      {:ueberauth, "~> 0.6.2"},
      {:ueberauth_github, "~> 0.8.0"},
      {:bypass, "~> 1.0", only: :test},
      {:ex_machina, "~> 2.2", only: :test},
      {:excoveralls, "~> 0.10", only: :test},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.3"}
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
