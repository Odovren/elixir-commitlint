defmodule Commitlint do
  @moduledoc """
  Documentation for `Commitlint`.
  """

  @type_regex ~r/^(?<type>[a-z]+)(?:\((?<scope>[a-z]+)\))?!?: (?<description>.+)$/
  @sections_regex ~r/^(?<header>.+)(?:\n\n(?<body>.+))?(?:\n\n(?<footer>.+))?$/m

  @doc """
  Get the sections of a commit message.
  """
  @spec get_sections(String.t()) :: %{optional(String.t()) => String.t()}
  defp get_sections(input) do
    Regex.named_captures(@sections_regex, input)
  end

  @doc """
  Make sure the commit message type is allowed.
  Expected format: "type: message" or "type(scope): message"

  ## Examples

      iex> Commitlint.lint_header("feat: add linting to commit messages")
      :ok

      iex> Commitlint.lint_header("inexistent: add a test commit")
      {:error, "Invalid commit type: inexistent"}
  """
  @spec lint_header(String.t()) :: :ok | {:error, String.t()}
  defp lint_header(input) do
    allowed_types = Application.get_env(:commitlint, :allowed_types)
    captured = Regex.named_captures(@type_regex, input)

    if captured["type"] in allowed_types do
      :ok
    else
      {:error, "Invalid commit type: #{captured["type"]}"}
    end
  end


  @doc """
  Lint the commit message.

  ## Examples

      iex> Commitlint.lint!("feat: add linting to commit messages")
      :ok

      iex> Commitlint.lint!("inexistent: add a test commit")
      ** (Commitlint.LintException) Invalid commit type: inexistent

  """
  @spec lint!(String.t()) :: :ok
  def lint!(input) do
    sections = get_sections(input)

    case lint_header(sections["header"]) do
      :ok -> :ok
      {:error, message} -> raise Commitlint.LintException, message: message
    end
  end
end
