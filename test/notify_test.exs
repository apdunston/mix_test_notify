defmodule NotifyTest do
  use ExUnit.Case
  alias MixTestNotify.TestOutputParser
  alias MixTestNotify.Config

  test "TestOutputParser.parse raises exception" do
    assert_raise(RuntimeError, fn() ->
      TestOutputParser.parse(ipsum)
    end)
  end

  test "TestOutputParser.error_check" do
    assert TestOutputParser.error_check(real_world_input) == {:no_error, real_world_input}
    assert TestOutputParser.error_check(real_world_compile_error) == {:error, "Compile Error", "test/thing_test.exs:111:"}
    assert TestOutputParser.error_check(real_world_syntax_error) == {:error, "Syntax Error", "test/thing_test.exs:113:"}
    assert TestOutputParser.error_check(real_world_key_error) == {:error, "Key Error", "key :group_id not found"}
  end

  test "TestOutputParser.parse" do
    string = ipsum <> "Finished in 0.05 seconds (0.05s on load, 0.00s on tests)\n1 tests, 0 failures"
    assert TestOutputParser.parse(string) == {1, 0}
    string = ipsum <> "Finished in 0.05 seconds (0.05s on load, 0.00s on tests)\n1 tests, 1 failure"
    assert TestOutputParser.parse(string) == {0, 1}
    string = ipsum <> "Finished in 0.05 seconds (0.05s on load, 0.00s on tests)\n212 tests, 117 failures"
    assert TestOutputParser.parse(string) == {95, 117}
    string = ipsum <> "Finished in 0.05 seconds (0.05s on load, 0.00s on tests)\n9999999 tests, 1 failures" <> ipsum
    assert TestOutputParser.parse(string) == {9999998, 1}
    string = ipsum <> "Finished in 0.05 seconds (0.05s on load, 0.00s on tests)\n0 tests, 0 failures"
    assert TestOutputParser.parse(string) == {0, 0}
    assert TestOutputParser.parse(real_world_input) == {25, 0}
  end

  test "MixTestNotify.to_title_message_sound_icon integration" do
    assert MixTestNotify.to_title_message_sound_icon({1, 1}) ==
      {"Fail", "1 Passed, 1 Failed", "Basso", Application.app_dir(:mix_test_notify, "priv/icons/x.png")}
    assert MixTestNotify.to_title_message_sound_icon({0, 1}) ==
      {"Fail", "0 Passed, 1 Failed", "Basso", Application.app_dir(:mix_test_notify, "priv/icons/x.png")}
    assert MixTestNotify.to_title_message_sound_icon({1, 0}) ==
      {"Win", "1 Passed, 0 Failed", "Blow", Application.app_dir(:mix_test_notify, "priv/icons/checkmark.png")}
    assert MixTestNotify.to_title_message_sound_icon({1000, 0}) ==
      {"Win", "1000 Passed, 0 Failed", "Blow", Application.app_dir(:mix_test_notify, "priv/icons/checkmark.png")}
    assert MixTestNotify.to_title_message_sound_icon({1000, 9999}) ==
      {"Fail", "1000 Passed, 9999 Failed", "Basso", Application.app_dir(:mix_test_notify, "priv/icons/x.png")}
  end

  test "Config.config_or_default" do
    Application.put_env(:mix_test_notify, :foo, "alpha")
    assert Config.config_or_default(:foo, "bravo") == "alpha"
    assert Config.config_or_default(:bar, "bravo") == "bravo"
  end

  def ipsum do
    ~s"""
Lorem ipsum Dane dolor sit amet, consectetur adipiscing Dane Dane elit. Dane Ut posuere lorem arcu, sed Dane efficitur leo Dane volutpat id. Donec Dane in lectus arcu. Fusce eget turpis Dane est. Fusce Dane vel sagittis elit. Dane Morbi ac ipsum nec Dane orci aliquet ullamcorper. Vestibulum vel lorem Dane sit Dane amet orci rhoncus tristique. Dane Nunc suscipit dui sit amet elit Dane euismod lacinia. Proin Dane posuere blandit Dane Dane magna, ac porta leo vulputate Dane vitae. Nam Dane quis vulputate enim. Praesent vel consectetur Dane augue. Cras lobortis Dane fermentum mauris id Dane commodo. Sed eu elit sed Dane eros ultricies congue Dane eget vel Dane tortor. Suspendisse rhoncus, Dane Dane lectus in Dane laoreet hendrerit, dui Dane ipsum imperdiet mauris, eu Dane tincidunt turpis magna ut metus. Dane Maecenas eros nibh, mollis eget leo Dane sit Dane amet, rhoncus pulvinar neque. Dane Curabitur tristique convallis Dane justo. Ut Dane Dane maximus, ligula ut venenatis laoreet, Dane Dane magna eros mattis Dane magna, Dane sed Dane eleifend Dane libero urna Dane nec metus. Morbi id Dane vulputate Dane ipsum, vestibulum Dane dignissim dui. Nunc auctor sit amet Dane urna in pharetra. In at sem Dane Dane sit amet enim rhoncus Dane Dane semper non Dane ut augue. Dane Praesent Dane non facilisis Dane justo. Nulla nisi Dane nulla, lobortis sed hendrerit Dane non, imperdiet ac odio. Dane Sed at dignissim Dane lorem. Dane Fusce augue sem, auctor elementum lectus Dane tristique, interdum facilisis leo. Cras viverra Dane ultricies ante, Dane eget Dane laoreet nulla. Phasellus imperdiet Dane sagittis Dane nunc et feugiat. In elit ligula, Dane molestie sit amet felis vitae, Dane Dane accumsan Dane faucibus Dane enim. Vestibulum at magna Dane a Dane velit consequat interdum. Dane Dane Curabitur Dane vitae lacinia mi, eu Dane mattis mi. Vivamus at ultricies Dane eros. Maecenas semper Dane finibus enim, Dane eget Dane eleifend nulla Dane dignissim in. Proin pretium Dane maximus sapien. Vivamus viverra dolor Dane Dane nec Dane erat egestas, ac mollis Dane Dane felis Dane finibus. Suspendisse id fermentum ante. Morbi Dane rutrum mauris eget sodales dapibus. Dane Dane Maecenas ut consectetur justo. Donec Dane nulla Dane dolor, sagittis ac Dane quam ultrices, iaculis facilisis Dane turpis. Nam ligula nisl, vehicula Dane vitae rhoncus in, gravida Dane quis neque. Phasellus commodo est vitae Dane dui tristique faucibus. In Dane vehicula Dane a ipsum Dane ac luctus. Dane Cras Dane tempor Dane velit nec sapien varius, vitae condimentum Dane Dane lorem lobortis. Proin sagittis Dane Dane id Dane ipsum eu hendrerit. Phasellus ac erat Dane pharetra, fringilla Dane mauris vel, volutpat orci. Cras orci Dane augue, vestibulum pharetra Dane facilisis in, porttitor Dane vitae nisl. Lorem ipsum Dane dolor sit Dane amet, consectetur Dane adipiscing Dane elit. Lorem ipsum Dane dolor sit amet, consectetur Dane adipiscing elit. Donec in augue ac Dane libero Dane tempus dapibus Dane Dane nec id Dane Dane elit. Nulla facilisi. Integer Dane varius elit nulla, Dane non vehicula est ultricies in. Dane Curabitur nec purus metus. Vestibulum Dane venenatis purus quis diam imperdiet molestie. Dane Ut Dane fermentum Dane risus ut congue Dane cursus. Mauris accumsan libero ex, at Dane egestas mi scelerisque a. Dane Suspendisse ipsum erat, elementum Dane eget fringilla ut, egestas vitae Dane Dane neque. Dane Sed eu urna dignissim, bibendum risus Dane Dane Dane ac, pharetra erat. Dane Dane Mauris mi purus, efficitur quis Dane aliquet sit amet, gravida vel enim. Dane In vulputate nulla eget Dane lectus gravida, ut euismod nisi vehicula. Dane Nulla facilisi. Dane Mauris volutpat posuere erat, nec rhoncus Dane Dane felis Dane sollicitudin Dane ut. Ut quis scelerisque Dane nunc. Donec lobortis ex sit Dane amet Dane suscipit faucibus. Dane Maecenas Dane malesuada Dane Dane quam vel dapibus sagittis. Dane Ut Dane Dane tincidunt massa vel Dane ultricies euismod. Nullam Dane posuere Dane porttitor ligula, ac auctor nisl viverra Dane eu. In mollis Dane mi a metus Dane Dane finibus pharetra. Nam Dane pellentesque Dane risus Dane ut aliquet laoreet. Dane Sed egestas, Dane ante Dane eu Dane venenatis posuere, felis elit hendrerit eros, Dane in tristique erat lorem dictum neque. Dane Nam sit amet Dane dolor vitae Dane leo pharetra Dane rhoncus. Maecenas auctor erat ut Dane nisl pulvinar rutrum. Praesent Dane in odio Dane lectus. Sed Dane varius, Dane enim in suscipit cursus, elit Dane ipsum euismod erat, sed tempor velit Dane nisl Dane quis augue. Dane Dane Nam tincidunt congue Dane magna, Dane et feugiat ex pulvinar ut. Dane Fusce Dane tincidunt mauris augue, gravida commodo Dane justo vestibulum Dane aliquam.
"""
  end

  def real_world_input do
    ~s"""
You have configured application :mix_test_watch in your configuration
file but the application is not available.

This usually means one of:

1. You have not added the application as a dependency in a mix.exs file.

2. You are configuring an application that does not really exist.

Please ensure :mix_test_watch exists or remove the configuration.

.........................

Finished in 0.3 seconds
25 tests, 0 failures

Randomized with seed 104380

** (RuntimeError) Invalid input
    lib/mix/tasks/test/notify.ex:19: Mix.Tasks.Test.Notify.get_tests_failures/1
    lib/mix/tasks/test/notify.ex:12: Mix.Tasks.Test.Notify.run/1
    (mix) lib/mix/task.ex:296: Mix.Task.run_task/3
    (mix) lib/mix/cli.ex:58: Mix.CLI.run_task/2
    (elixir) lib/code.ex:363: Code.require_file/2
"""
  end

  def real_world_compile_error do
    ~s"""
warning: variable key is unused
  test/thing_test.exs:109

warning: variable key is unused
  test/thing_test.exs:114

** (CompileError) test/thing_test.exs:111: undefined function has_key?/2
    (stdlib) lists.erl:1337: :lists.foreach/2
    (stdlib) erl_eval.erl:670: :erl_eval.do_apply/6
    (elixir) lib/code.ex:363: Code.require_file/2
    (elixir) lib/kernel/parallel_require.ex:56: anonymous fn/2 in Kernel.ParallelRequire.spawn_requires/5


** (RuntimeError) Invalid input
    lib/mix/tasks/test/notify.ex:19: Mix.Tasks.Test.Notify.get_tests_failures/1
    lib/mix/tasks/test/notify.ex:12: Mix.Tasks.Test.Notify.run/1
    (mix) lib/mix/task.ex:296: Mix.Task.run_task/3
    (elixir) lib/enum.ex:651: Enum."-each/2-lists^foreach/1-0-"/2
    (elixir) lib/enum.ex:651: Enum.each/2
    (mix) lib/mix/task.ex:296: Mix.Task.run_task/3
    (mix) lib/mix/cli.ex:58: Mix.CLI.run_task/2
"""
  end

  def real_world_syntax_error do
    ~s"""
** (SyntaxError) test/thing_test.exs:113: syntax error before: t
    (elixir) lib/code.ex:363: Code.require_file/2
    (elixir) lib/kernel/parallel_require.ex:56: anonymous fn/2 in Kernel.ParallelRequire.spawn_requires/5


** (RuntimeError) Invalid input
    lib/mix/tasks/test/notify.ex:51: Mix.Tasks.Test.Notify.get_tests_failures/1
    lib/mix/tasks/test/notify.ex:24: Mix.Tasks.Test.Notify.notify/1
    (mix) lib/mix/task.ex:296: Mix.Task.run_task/3
    (elixir) lib/enum.ex:651: Enum."-each/2-lists^foreach/1-0-"/2
    (elixir) lib/enum.ex:651: Enum.each/2
    (mix) lib/mix/task.ex:296: Mix.Task.run_task/3
    (mix) lib/mix/cli.ex:58: Mix.CLI.run_task/2
"""
  end

  def real_world_key_error do
    ~s"""
** (KeyError) key :group_id not found in: %FunRequest{batch_requests: [], created_at: nil, environment_token: nil, id: "ID", sftp_completed_at: nil}
    (stdlib) :maps.update(:group_id, "REQUEST GROUP ID", %FunRequest{batch_requests: [], created_at: nil, environment_token: nil, id: "ID", sftp_completed_at: nil})
    (au) lib/vantiv/litle_request.ex:2: anonymous fn/2 in FunRequest.__struct__/1
    (elixir) lib/enum.ex:1623: Enum."-reduce/3-lists^foldl/2-0-"/3
    (au) expanding struct: FunRequest.__struct__/1
    test/litle_request_test.exs:53: LitleRequestTest."test to_storage_format"/1
    (elixir) lib/code.ex:363: Code.require_file/2
    (elixir) lib/kernel/parallel_require.ex:56: anonymous fn/2 in Kernel.ParallelRequire.spawn_requires/5

"""
  end
end