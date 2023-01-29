defmodule Commitlint do
  @moduledoc "README.md" |> File.read!() |> String.trim()
  @type lint_result :: :ok | {:error, String.t()}

  @type_regex ~r/^(?<type>[a-z]+)(?:\((?<scope>[a-z]+)\))?!?: (?<description>.+)$/
  @footer_regex ~r/^(?<label>.+?): (?<value>.+)$/
  @default_allowed_types ~w(feat fix docs style refactor perf test build ci chore revert)

  @spec get_sections(String.t()) :: [String.t()]
  defp get_sections(input) do
    # Get the sections of a commit message.
    String.split(input, "\n\n")
  end

  defp lint_header([header | rest]) do
    # Make sure the commit message type is allowed.
    # Expected format: "type: message" or "type(scope): message"

    # ## Examples

    # iex> Commitlint.lint_header("feat: add linting to commit messages")
    # :ok

    # iex> Commitlint.lint_header("inexistent: add a test commit")
    # {:error, "Invalid commit type: inexistent"}

    allowed_types = Application.get_env(:commitlint, :allowed_types, @default_allowed_types)
    captured = Regex.named_captures(@type_regex, header)

    cond do
      check_skip(header) ->
        IO.puts("Skipping commit message: #{header}")
        :ok

      captured["type"] not in allowed_types ->
        {:error, "Invalid commit type: #{captured["type"]}"}

      String.trim(captured["description"]) == "" ->
        {:error, "Commit message must have a description"}

      true ->
        lint_body(rest)
    end
  end

  @spec check_skip(String.t()) :: boolean()
  defp check_skip(header) do
    # Check if the commit message should be skipped.
    String.starts_with?(header, "Merge ")
  end

  @spec lint_body([String.t()]) :: lint_result
  defp lint_body([]), do: :ok

  defp lint_body([section | rest]) do
    # Make sure the commit message body is valid.
    if Enum.empty?(rest) and Regex.match?(@footer_regex, section) do
      lint_footer(section)
    else
      lint_body(rest)
    end
  end

  @spec lint_footer(String.t()) :: lint_result
  defp lint_footer(footer) do
    # Make sure the footer lines are valid.
    String.split(footer, "\n", trim: true) |> lint_footer_line
  end

  @spec lint_footer_line([String.t()]) :: lint_result
  defp lint_footer_line([]), do: :ok

  defp lint_footer_line([line | rest]) do
    # Make sure the footer lines are valid.
    if Regex.match?(@footer_regex, line) do
      lint_footer_line(rest)
    else
      {:error, "Invalid footer line: #{line}"}
    end
  end

  @spec filter_out_comments(String.t()) :: String.t()
  defp filter_out_comments(input) do
    # Removes all lines starting with a hash (#).
    String.split(input, "\n")
    |> Enum.reject(&String.starts_with?(&1, "#"))
    |> Enum.join("\n")
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
    result = filter_out_comments(input) |> get_sections |> lint_header

    case result do
      :ok -> :ok
      {:error, message} -> raise Commitlint.LintException, message: message
    end
  end

  defmodule Setup do
    @moduledoc """
    Not meant to be used directly.
    This will make sure that the files in /priv are correctly installed when compiling the project.
    It lives in its own submodule so that it does not pollute runtime code.

    This was inspired by the way [elixir-pre-commit](https://github.com/dwyl/elixir-pre-commit/) works.
    """
    copy = Mix.Project.deps_path() |> Path.join("commitlint/priv/commit-msg")
    to = Mix.Project.deps_path() |> Path.join("../.git/hooks/commit-msg")

    if not File.exists?(Path.dirname(to)) do
      File.mkdir_p!(Path.dirname(to))
    end

    copy |> File.copy(to)
    to |> File.chmod(0o755)
  end
end
