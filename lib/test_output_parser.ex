defmodule MixTestNotify.TestOutputParser do
  @moduledoc """
  Processes output from running `mix test`
  """

  @doc """
  Returns `{successes, failures}`.
  """
  def parse(output) do
    [tests, failures] = parse_tests_failures(output)
    {(tests - failures), failures}
  end

  @doc """
  Returns `{:error, type, message}` or `{:no_error, value}` where value is the
  input value.
  """
  def error_check(value) when is_bitstring(value), do:
    { Regex.run(compile_error_regex, value), value } |> do_error_check

  defp do_error_check({nil, output}), do: {:no_error, output}
  defp do_error_check({results, _output}) when is_list(results) do
    [_match, title, message] = results
    {:error, "#{title} Error", escape_quote(message)}
  end

  defp escape_quote(error), do:
    Regex.replace(~r/"/, error, "\\\"")

  defp parse_tests_failures(value) when is_bitstring(value), do:
    mix_test_regex
    |> Regex.run(value)
    |> do_parse_tests_failures
    |> get_integers

  defp do_parse_tests_failures(nil), do: raise "Invalid input"
  defp do_parse_tests_failures(value) when is_list(value), do: Enum.drop(value, 1)

  defp get_integers(list = [_tests, _failures]) do
    list |> Enum.map(fn(x) -> x |> Integer.parse |> elem(0) end)
  end

  defp mix_test_regex, do: ~r/Finished in .* seconds.*\n(\d+) tests, (\d+) failure/

  defp compile_error_regex, do: ~r/\((Compile|Syntax|Key)Error\) (.*:\d*:|key .* not found)/

end