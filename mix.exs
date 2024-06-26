defmodule Alarmclock.MixProject do
  use Mix.Project

  def project do
    [
      app: :alarmclock,
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
      mod: {Alarmclock.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bandit, "~> 1.0"},
      {:quantum, "~> 3.0"},
      {:quantum_storage_persistent_ets, "~> 1.0"},
      {:tzdata, "~> 1.1"}
    ]
  end
end
