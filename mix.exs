defmodule Commitlint.MixProject do
  use Mix.Project

  def project do
    [
      app: :commitlint,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [plt_add_apps: [:mix]],
      name: "commitlint",
      description: "A commit message linter for Elixir",
      source_url: "https://github.com/Odovren/elixir-commitlint",
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      env: [
        allowed_types: [
          "feat",
          "fix",
          "docs",
          "style",
          "refactor",
          "perf",
          "test",
          "build",
          "ci",
          "chore",
          "revert"
        ]
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:pre_commit, "~> 0.3.4", only: :dev},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      files: ~w(lib priv mix.exs README.md LICENSE .formatter.exs),
      maintainers: ["Odovren"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/Odovren/elixir-commitlint"
      }
    ]
  end
end
