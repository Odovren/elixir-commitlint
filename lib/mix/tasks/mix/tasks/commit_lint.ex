defmodule Mix.Tasks.CommitLint do
  @moduledoc """
  Lint commit messages. Parses the messages passed through STDIN.
  """

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("compile")

    input = IO.read(:stdio, :line)

    try do
      Commitlint.lint!(input)
    rescue
      e ->
        Mix.shell().error(e.message)
        exit({:shutdown, 1})
    end
  end
end
