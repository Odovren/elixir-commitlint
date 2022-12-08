defmodule Commitlint.LintException do
  @moduledoc """
  Exception raised when a commit message is not valid.
  """

  defexception [:message]

  @doc """
  Raise a `Commitlint.LintException` exception.
  """
  @spec raise!(String.t()) :: no_return()
  def raise!(message) do
    raise %Commitlint.LintException{message: message}
  end
end
