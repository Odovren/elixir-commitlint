defmodule Commitlint do
  @moduledoc """
  Documentation for `Commitlint`.
  """
  @type lint_result :: :ok | {:error, String.t()}

  @type_regex ~r/^(?<type>[a-z]+)(?:\((?<scope>[a-z]+)\))?!?: (?<description>.+)$/
  @footer_regex ~r/^(?<label>.+?): (?<value>.+)$/

  @doc """
  Get the sections of a commit message.
  """
  @spec get_sections(String.t()) :: %{optional(String.t()) => String.t()}
  defp get_sections(input) do
    String.split(input, "\n\n")
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
  defp lint_header([header | rest]) do
    allowed_types = Application.get_env(:commitlint, :allowed_types)
    captured = Regex.named_captures(@type_regex, header)

    cond do
      captured["type"] not in allowed_types -> {:error, "Invalid commit type: #{captured["type"]}"}
      String.trim(captured["description"]) == "" -> {:error, "Commit message must have a description"}
      true -> lint_body(rest)
    end
  end


  @doc """
  Make sure the commit message body is valid.
  """
  @spec lint_body([String.t()]) :: lint_result
  defp lint_body([]), do: :ok
  defp lint_body([section | rest]) do
    if Enum.empty?(rest) and Regex.match?(@footer_regex, section) do
      lint_footer(section)
    else
      lint_body(rest)
    end
  end

  @doc """
  Make sure the footer lines are valid.
  """
  @spec lint_footer(String.t()) :: lint_result
  defp lint_footer(footer) do
    String.split(footer, "\n", trim: true) |> lint_footer_line
  end

  @doc """
  Make sure the footer lines are valid.
  """
  @spec lint_footer_line([String.t()]) :: lint_result
  defp lint_footer_line([]), do: :ok
  defp lint_footer_line([line | rest]) do
    if Regex.match?(@footer_regex, line) do
      lint_footer_line(rest)
    else
      {:error, "Invalid footer line: #{line}"}
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
    result = get_sections(input) |> lint_header

    case result do
      :ok -> :ok
      {:error, message} -> raise Commitlint.LintException, message: message
    end
  end
end
