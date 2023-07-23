defmodule Knapsack.MixProject do
  use Mix.Project

  def project do
    [
      app: :knapsack_ex,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:nx, path: "./nx"},
      {:ex_doc, "~> 0.30", only: :docs, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},

       {:nx, "~> 0.5"}
      # {:exla, "~> 0.1.0-dev", github: "elixir-nx/nx", sparse: "exla"},
    ]
  end
end
