import Config

if config_env() == :prod do
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  live_view_salt =
    System.get_env("LIVE_VIEW_SALT") ||
      raise """
      environment variable LIVE_VIEW_SALT is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  app_name = System.get_env("FLY_APP_NAME", "elixir-companies")

  host =
    case app_name do
      "elixir-companies" -> "elixir-companies.com"
      app_name -> "#{app_name}.fly.dev"
    end

  config :school_house, SchoolHouseWeb.Endpoint,
    http: [
      port: String.to_integer(System.get_env("PORT", "4000")),
      transport_options: [socket_opts: [:inet6]]
    ],
    secret_key_base: secret_key_base,
    url: [scheme: "https", host: host, port: 443],
    live_view: [signing_salt: live_view_salt],
    server: true

  config :libcluster,
    topologies: [
      fly6pn: [
        strategy: Cluster.Strategy.DNSPoll,
        config: [
          polling_interval: 5_000,
          query: "#{app_name}.internal",
          node_basename: app_name
        ]
      ]
    ]
end
