import Config

if config_env() == :dev do
  config :pre_commit,
    commands: ["format --check-formatted", "test", "credo", "dialyzer"]
end
