defmodule ArchethicPrice.MixProject do
  use Mix.Project

  def project do
    [
      app: :archethic_price,
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
      mod: {ArchethicPrice.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mint, "~> 1.5"},
      {:jason, "~> 1.4"},
      {:exjsonpath, "~> 0.9.0"},
      {:plug_cowboy, "~> 2.6"},

      # dev
      {:credo, "~> 1.7", runtime: false},
      {:dialyxir, "~> 1.4", runtime: false}
    ]
  end
end
