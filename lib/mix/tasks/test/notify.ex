defmodule Mix.Tasks.Test.Notify do
  use Mix.Task

  @shortdoc "Run mix tests and send an OSX notification."

  def run(_args) do
    { output, _exit_code } = System.cmd("mix", ["test"])
    Mix.shell.info(output)

    [tests, failures] =
      output
      |> get_tests_failures
      |> get_integers

    successes = tests - failures
    System.cmd("osascript", ["-e", osascript(successes, failures, sound)])
  end

  def get_tests_failures(value), do:
    Regex.run(~r/(\d+) tests, (\d+) failure/, value) |> Enum.drop(1)

  def get_integers(list = [_tests, _failures]) do
    list |> Enum.map(fn(x) -> x |> Integer.parse |> elem(0) end)
  end

  def title(0), do: win_title
  def title(_failures), do: fail_title

  def message(successes, failures), do: "#{successes} Passed, #{failures} Failed"

  def osascript(successes, 0, true), do:
    osascript_with_sound(successes, 0, win_sound)

  def osascript(successes, failures, true), do:
    osascript_with_sound(successes, failures, fail_sound)

  def osascript(successes, failures, _sound) do
    "display notification \"#{message(successes, failures)}\"" <>
      " with title \"#{title(failures)}\""
  end

  def osascript_with_sound(successes, failures, name), do:
    osascript(successes, failures, nil) <> " sound name \"#{name}\""

  def sound, do: config_or_default(:sound, false)
  def win_sound, do: config_or_default(:win_sound, "Blow")
  def fail_sound, do: config_or_default(:fail_sound, "Basso")
  def win_title, do: config_or_default(:win_title, "Win")
  def fail_title, do: config_or_default(:fail_title, "Fail")

  def config_or_default(item, default) when is_atom(item) and not is_nil(item) and not is_boolean(item) do
    config_or_default(Application.get_env(:mix_test_notify, item), default)
  end

  def config_or_default(nil, default) do
    default
  end

  def config_or_default(item, _default) do
   item
 end


end