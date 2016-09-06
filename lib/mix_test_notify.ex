defmodule MixTestNotify do
  @moduledoc """
  Does the business of notification
  """
  alias MixTestNotify.Config
  alias MixTestNotify.TestOutputParser

  def notify_of_output(output) do
    output
    |> TestOutputParser.parse
    |> to_title_message_sound_icon
    |> notify
  end

  def to_title_message_sound_icon({successes, failures}) do
    {
      which_title(failures),
      "#{successes} Passed, #{failures} Failed",
      which_sound(failures),
      which_icon(failures)
    }
  end
  
  def notify({title, message, sound, icon}), 
    do: notify(title, message, sound, icon)
  def notify(title, message, sound, icon),
    do: do_notify(Config.use_sound?, title, message, sound, icon)
  
  defp do_notify(false, title, message, _, icon),
    do: Notifier.notify(%{title: title, message: message, icon: icon})
  defp do_notify(true, title, message, sound, icon),
    do: Notifier.notify(
      %{title: title, message: message, sound: sound, icon: icon})

  defp which_title(0), do: Config.win_title
  defp which_title(_failures), do: Config.fail_title

  defp which_sound(0), do: Config.win_sound
  defp which_sound(_failures), do: Config.fail_sound

  defp which_icon(0), do: Config.win_icon
  defp which_icon(_failures), do: Config.fail_icon
end
