# Commitlint

This project is an implementation of the [Conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) 
specification.
This is inspired by the JS library pendant [commitlint](https://www.npmjs.com/package/commitlint).
The hook installation was inspired by [elixir-pre-commit](https://github.com/dwyl/elixir-pre-commit)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `commitlint` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:commitlint, "~> 0.1.1"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/commitlint>.

## Configuration

The configuration is done in the `config/config.exs` file. The default configuration is:

```elixir
config :commitlint,
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
```

## Usage

The package provides a mix task `commit_lint`. If you want to try it out, you can run:

```bash
echo "feat: add commit linting" | mix commit_lint  # Should have exit error 0
echo "unknown: add commit linting" | mix commit_lint  # Should have exit error 1
```

Upon compilation, the package will install a commit-msg hook in the `.git/hooks` directory. This will take care of
running the commit linting on every commit.
