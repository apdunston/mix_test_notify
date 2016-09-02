defmodule MixTestNotify do
  @moduledoc """
  Does the business of notification
  """
  alias MixTestNotify.Config
  alias MixTestNotify.TestOutputParser

  def notify_of_output(output) do
    output
    |> TestOutputParser.parse
    |> to_title_message_sound
    |> notify
  end

  def to_title_message_sound({successes, failures}) do
    {
      which_title(failures),
      "#{successes} Passed, #{failures} Failed",
      which_sound(failures)
    }
  end
  
  def notify({title, message, sound}), do: notify(title, message, sound)
  def notify(title, message, sound),
    do: do_notify(Config.use_sound?, title, message, sound)
  
  defp do_notify(false, title, message, _),
    do: Notifier.notify(title, message)
  defp do_notify(true, title, message, sound),
    do: Notifier.notify(%{title: title, message: message, sound: sound})

  defp which_title(0), do: Config.win_title
  defp which_title(_failures), do: Config.fail_title

  defp which_sound(0), do: Config.win_sound
  defp which_sound(_failures), do: Config.fail_sound
end
