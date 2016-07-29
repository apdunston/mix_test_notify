defmodule Mix.Tasks.Test.Notify do
  use Mix.Task

  @shortdoc "Run mix tests and send an OSX notification."

  def run(_args) do
    { output, _exit_code } = System.cmd("mix", ["test"])
    [tests, failures] =
      output
      |> get_tests_failures
      |> get_integers

    successes = tests - failures
    Mix.shell.info(output)
    System.cmd("osascript", ["-e", "display notification \"#{message(successes, failures)}\" with title \"#{headline(failures)}\""])
  end

  def get_tests_failures(value), do:
    Regex.run(~r/(\d+) tests, (\d+) failures/, value) |> Enum.drop(1)

  def get_integers(list) do
    list |> Enum.map(fn(x) -> x |> Integer.parse |> elem(0) end)
  end

  def headline(0), do: "Win"
  def headline(_failures), do: "Fail"

  def message(successes, failures), do: "#{successes} Passed, #{failures} Failed"
end