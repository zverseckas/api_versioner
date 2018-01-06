defmodule ApiVersioner.Mixfile do
  use Mix.Project

  def project do
    [
      app: :api_versioner,
      version: "0.1.0",
      elixir: "~> 1.3",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      preferred_cli_env: [
       "coveralls": :test,
       "coveralls.detail": :test,
       "coveralls.html": :test,
       "coveralls.post": :test,
       "coveralls.travis": :test
      ],
     test_coverage: [tool: ExCoveralls]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 1.1.1"},
      {:plug, "~> 1.4.3"},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:mock, "~> 0.3.0", only: :test},
      {:dogma, "~> 0.1", only: :dev},
      {:excoveralls, "~> 0.8", only: :test}
    ]
  end

  defp package do
    [
      maintainers: ["zverseckas"],
      licenses: ["MIT"],
      links: %{
        GitHub: "https://github.com/zverseckas/api_versioner"
      }
    ]
  end
end
