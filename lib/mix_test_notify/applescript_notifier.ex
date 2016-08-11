defmodule MixTestNotify.ApplescriptNotifier do
  @moduledoc """
  Displays a notification via command-line Applescript.
  """
  @behaviour MixTestNotify.ExternalNotifier

  def notify(title, message) do
    notify(:no_sound, title, message, nil)
  end

  def notify(:sound, title, message, sound) do
    {title, message}
    |> make_applescript
    |> add_sound(sound)
    |> run_applescript
  end

  def notify(:no_sound, title, message, _sound) do
    {title, message}
    |> make_applescript
    |> run_applescript
  end

  defp make_applescript({title, message}),
    do: "display notification \"#{message}\" with title \"#{title}\""

  defp add_sound(applescript, sound_name),
    do: applescript <> " sound name \"#{sound_name}\""

  defp run_applescript(applescript), do:
    System.cmd("osascript", ["-e", applescript])
end
