defmodule ArchethicFAS.MixProject do
  use Mix.Project

  def project do
    [
      app: :archethic_fas,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ArchethicFAS.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # http client
      {:mint, "~> 1.5"},

      # http server
      {:plug_cowboy, "~> 2.6"},

      # json
      {:jason, "~> 1.4"},
      {:exjsonpath, "~> 0.9.0"},

      # https
      {:castore, "~> 1.0"},

      # dev
      {:credo, "~> 1.7", runtime: false},
      {:dialyxir, "~> 1.4", runtime: false}
    ]
  end
end
