defmodule KingOrQueen.MixProject do
  use Mix.Project

  def project do
    [
      app: :king_or_queen,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {KingOrQueen, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_crypto, "~> 0.10.0"},
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.1"},
      {:httpoison, "~> 1.5"}
    ]
  end
end
