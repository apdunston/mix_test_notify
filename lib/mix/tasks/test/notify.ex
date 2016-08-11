defmodule Mix.Tasks.Test.Notify do
  @moduledoc """
  OSX notifications for `mix test`. Best when used with the most excellent
  [mix test.watch](https://github.com/lpil/mix-test.watch).

  You can also call
  ```
  Mix.Tasks.Test.Notify.notify({:error, "Error type", "message body"})
  ```
  to send an error notification directly

  """

  @shortdoc "Run mix tests and send an OSX notification."

  use Mix.Task
  import MixTestNotify.Config, only: [sound?: 0, fail_sound: 0]
  alias MixTestNotify.ApplescriptNotifier
  alias MixTestNotify.TestOutputParser

  def run(_args) do
    try do
      mix_test
      |> output_to_shell
      |> TestOutputParser.error_check
      |> process_notification
    rescue e in RuntimeError ->
      ApplescriptNotifier.notify(sound?, "Unknown Error", e.message, fail_sound)
    end
  end

  def mix_test,
    do: System.cmd("mix", ["test"], stderr_to_stdout: true) |> elem(0)

  def output_to_shell(test_output) do
    Mix.shell.info(test_output)
    test_output
  end

  def process_notification({:error, title, message}),
    do: ApplescriptNotifier.notify(sound?, title, message, fail_sound)
  def process_notification({:no_error, output}),
    do: MixTestNotify.notify(output)

end