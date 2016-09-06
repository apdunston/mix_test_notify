defmodule Mix.Tasks.Test.Notify do
  @moduledoc """
  OSX notifications for `mix test`. Best when used with the most excellent
  [mix test.watch](https://github.com/lpil/mix-test.watch).
  """

  @shortdoc "Run mix tests and send an OSX notification."

  use Mix.Task
  import MixTestNotify.Config, only: [fail_sound: 0, fail_icon: 0]
  alias MixTestNotify.TestOutputParser

  def run(args) do
    try do
      args
      |> mix_test
      |> output_to_shell
      |> TestOutputParser.error_check
      |> process_notification
    rescue e in RuntimeError ->
      MixTestNotify.notify("Unknown Error", e.message, fail_sound)
    end
  end

  def mix_test(args),
    do: System.cmd("mix", ["test"|args], stderr_to_stdout: true) |> elem(0)

  def output_to_shell(test_output) do
    Mix.shell.info(test_output)
    test_output
  end

  def process_notification({:error, title, message}),
    do: MixTestNotify.notify(title, message, fail_sound, fail_icon)
  def process_notification({:no_error, output}),
    do: MixTestNotify.notify_of_output(output)

end