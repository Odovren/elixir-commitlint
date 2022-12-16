import Config

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

if config_env() == :dev do
  config :pre_commit,
    commands: ["format --check-formatted", "test", "credo", "dialyzer"]
end
