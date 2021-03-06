defmodule MyMicroService.MixProject do
  use Mix.Project



  def project do
    [

      app: :hello,

      #for Google App Engine
      #
      releases: [
        hello: [
          include_erts: true,
          include_executables_for: [:unix],
          applications: [
            runtime_tools: :permanent
          ]
        ]
      ],        
      version: "0.0.1",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug_cowboy, :plug, :poison, :crypto],
      mod: {MyMicroService, []}
      
    ]
  end


  # Run "mix help deps" to learn about dependencies.
defp deps do
  [
    {:plug_cowboy, "~> 2.4"},
    {:plug, "~> 1.6"},
    {:poison, "~> 3.1"},
    {:httpoison, "~> 1.8.0"},

    {:egd, github: "erlang/egd"},
    {:tesla, "~> 1.4.0"},
    {:json, "~> 1.4"},
    {:amnesia, "~> 0.2.8"},
    {:credo, "~> 1.4", only: [:dev, :test], runtime: false}


  ]
end
end
