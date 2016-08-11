defmodule MixTestNotify.Config do
  @moduledoc """
  Handles configuration f
  """
  def config_or_default(item, default) when is_atom(item) and not is_nil(item)
    and not is_boolean(item), do:
    do_config_or_default(Application.get_env(:mix_test_notify, item), default)

  def sound?, do: :sound |> config_or_default(false) |> do_sound?

  def win_sound, do: config_or_default(:win_sound, "Blow")

  def fail_sound, do: config_or_default(:fail_sound, "Basso")

  def win_title, do: config_or_default(:win_title, "Win")

  def fail_title, do: config_or_default(:fail_title, "Fail")

  defp do_config_or_default(nil, default), do: default
  defp do_config_or_default(item, _default), do: item

  defp do_sound?(true), do: :sound
  defp do_sound?(false), do: :no_sound
end