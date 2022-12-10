defmodule CommitlintTest do
  use ExUnit.Case
  doctest Commitlint

  test "raises if type is not allowed" do
    assert_raise Commitlint.LintException, fn ->
      Commitlint.lint!("inexistent: add a test commit")
    end
  end

  test "does not raise if type is allowed" do
    assert Commitlint.lint!("feat: add linting to commit messages") == :ok
    assert Commitlint.lint!("fix: add linting to commit messages") == :ok
    assert Commitlint.lint!("chore: add linting to commit messages") == :ok
  end

  test "allows type with scope" do
    assert Commitlint.lint!("feat(scope): add linting to commit messages") == :ok
  end

  test "allows type with scope and exclamation mark" do
    assert Commitlint.lint!("feat(scope)!: add linting to commit messages") == :ok
    assert Commitlint.lint!("feat!: add linting to commit messages") == :ok
  end

  test "allows commit with a body only" do
    assert Commitlint.lint!("""
    feat: add linting to commit messages

    body
    """) == :ok
  end

  test "allows commit with multiple body sections" do
    assert Commitlint.lint!("""
    feat: add linting to commit messages

    body

    body
    """) == :ok
  end

  test "allows commit with a footer only" do
    assert Commitlint.lint!("""
    feat: add linting to commit messages

    Acked-by: John Doe
    """) == :ok
  end

  test "allows commit with multiple footers" do
    assert Commitlint.lint!("""
    feat: add linting to commit messages

    Acked-by: John Doe
    Signed-off-by: Jane Doe
    """) == :ok
  end

  test "allows commit with a body and a footer" do
    assert Commitlint.lint!("""
    feat: add linting to commit messages

    body

    Acked-by: John Doe
    """) == :ok
  end

  test "raises if commit message has no description" do
    assert_raise Commitlint.LintException, fn ->
      Commitlint.lint!("feat: ")
    end
  end
end
