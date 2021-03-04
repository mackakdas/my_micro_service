config :hello, Hello.Endpoint,
    load_from_system_env: true,
    http: [port: {:system, "PORT"}],
    check_origin: false,
    server: true,
    root: ".",
    cache_static_manifest: "priv/static/cache_manifest.json"