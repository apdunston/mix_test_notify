defmodule MixTestNotify do
  @moduledoc """
  Does the business of notification
  """
  alias MixTestNotify.Config
  alias MixTestNotify.TestOutputParser
  alias MixTestNotify.ApplescriptNotifier

  def notify(output) do
    output
    |> TestOutputParser.parse
    |> to_title_message_sound
    |> send_to_external_notifier
  end

  def to_title_message_sound({successes, failures}) do
    {
      which_title(failures),
      "#{successes} Passed, #{failures} Failed",
      which_sound(failures)
    }
  end

  defp send_to_external_notifier({title, message, sound}),
    do: ApplescriptNotifier.notify(Config.sound?, title, message, sound)

  defp which_title(0), do: Config.win_title
  defp which_title(_failures), do: Config.fail_title

  defp which_sound(0), do: Config.win_sound
  defp which_sound(_failures), do: Config.fail_sound
end
