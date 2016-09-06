use Mix.Config


# Sample configuration:
config :mix_test_notify, :sound, true
# config :mix_test_notify, :win_sound, "Blow"
# config :mix_test_notify, :fail_sound, "Basso"
# config :mix_test_notify, :win_title, "Win"
# config :mix_test_notify, :fail_title, "Fail"

config :mix_test_watch, tasks: ["test.notify"]
