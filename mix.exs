defmodule Telco.MixProject do
  use Mix.Project

  def project do
    [
      app: :telco,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: aliases(),
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_mode), do: ["lib"]

  def application do
    [
      mod: {Telco.Application, []},
      extra_applications: [:logger],
    ]
  end

  defp aliases() do
    [
      test: "test --no-start",
    ]
  end

  defp deps do
    [
      {:phoenix_pubsub, "~> 1.0"},
    ]
  end
end
