defmodule CommitlintTest do
  use ExUnit.Case
  doctest Commitlint

  test "lints a commit message" do
    assert Commitlint.lint("feat: add a test commit") == :ok
  end
end
