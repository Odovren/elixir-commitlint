use Mix.Config

config :commitlint,
  allowed_types: [
    "build",
    "chore",
    "ci",
    "docs",
    "feat",
    "fix",
    "perf",
    "refactor",
    "revert",
    "style",
    "test"
  ]


config :pre_commit, commands: ["test", "credo"]
