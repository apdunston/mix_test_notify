defmodule Mix.Tasks.Test.Notify do
  use Mix.Task

  @shortdoc "Run mix tests and send an OSX notification."

  def run(_args) do
    { output, _exit_code } = System.cmd("mix", ["test"], stderr_to_stdout: true)
    Mix.shell.info(output)

    output
    |> compile_error_check
    |> notify
  end

  def notify({:error, type, error}) do
    {type, error}
    |> sanitize_error
    |> error_applescript(sound)
    |> run_applescript
  end

  def notify({:compiles, output}) do
    try do
      [tests, failures] =
        output
        |> get_tests_failures
        |> get_integers

      successes = tests - failures
      completed_test_applescript(successes, failures, sound())
      |> run_applescript
    rescue e in RuntimeError ->
      notify({:error, "Unknown", e.message})
    end
  end

  defp sanitize_error({type, error}), do:
    {type,  Regex.replace(~r/"/, error, "\\\"")}

  defp error_applescript({type, error}, false), do:
    "display notification \"#{error}\" with title \"#{type} Error\""

  defp error_applescript({type, error}, true), do:
    error_applescript({type, error}, false) <> " sound name \"#{fail_sound}\""

  defp run_applescript(applescript), do:
    System.cmd("osascript", ["-e", applescript])

  def compile_error_check(value) when is_bitstring(value), do:
    { Regex.run(compile_error_regex, value), value } |> compile_error_check

  def compile_error_check({results, _output}) when is_list(results), do:
    {:error, Enum.at(results, 1), Enum.at(results, 2)}

  def compile_error_check({nil, output}), do: #!!ADRIAN
    {:compiles, output}

  def get_tests_failures(value) when is_bitstring(value), do:
    mix_test_regex |> Regex.run(value) |> do_get_tests_failures

  def do_get_tests_failures(nil), do: raise "Invalid input"
  def do_get_tests_failures(value) when is_list(value), do: Enum.drop(value, 1)

  def title(0), do: win_title
  def title(_failures), do: fail_title

  def message(successes, failures), do: "#{successes} Passed, #{failures} Failed"

  def config_or_default(item, default) when is_atom(item) and not is_nil(item) and not is_boolean(item), do:
    do_config_or_default(Application.get_env(:mix_test_notify, item), default)
  def do_config_or_default(nil, default), do: default
  def do_config_or_default(item, _default), do: item

  def completed_test_applescript(successes, 0, true), do:
    applescript_with_sound(successes, 0, win_sound)

  def completed_test_applescript(successes, failures, true), do:
    applescript_with_sound(successes, failures, fail_sound)

  def completed_test_applescript(successes, failures, false), do:
    "display notification \"#{message(successes, failures)}\"" <>
      " with title \"#{title(failures)}\""

  defp applescript_with_sound(successes, failures, name), do:
    completed_test_applescript(successes, failures, false) <> " sound name \"#{name}\""

  defp get_integers(list = [_tests, _failures]) do
    list |> Enum.map(fn(x) -> x |> Integer.parse |> elem(0) end)
  end

  defp sound, do: config_or_default(:sound, false)
  defp win_sound, do: config_or_default(:win_sound, "Blow")
  defp fail_sound, do: config_or_default(:fail_sound, "Basso")
  defp win_title, do: config_or_default(:win_title, "Win")
  defp fail_title, do: config_or_default(:fail_title, "Fail")

  defp mix_test_regex, do: ~r/Finished in .* seconds.*\n(\d+) tests, (\d+) failure/

  defp compile_error_regex, do: ~r/\((Compile|Syntax|Key)Error\) (.*:\d*:|key .* not found)/
end