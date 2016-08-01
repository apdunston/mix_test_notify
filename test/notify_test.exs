defmodule NotifyTest do
  use ExUnit.Case
  import Mix.Tasks.Test.Notify

  test "get_tests_failures raises exception" do
    assert_raise(RuntimeError, fn() -> get_tests_failures(
      ipsum) end)
  end

  test "get_tests_failures" do
    string = ipsum <> "Finished in 0.05 seconds (0.05s on load, 0.00s on tests)\n1 tests, 0 failures"
    assert get_tests_failures(string) == ["1","0"]
    string = ipsum <> "Finished in 0.05 seconds (0.05s on load, 0.00s on tests)\n1 tests, 1 failure"
    assert get_tests_failures(string) == ["1","1"]
    string = ipsum <> "Finished in 0.05 seconds (0.05s on load, 0.00s on tests)\n212 tests, 117 failures"
    assert get_tests_failures(string) == ["212","117"]
    string = ipsum <> "Finished in 0.05 seconds (0.05s on load, 0.00s on tests)\n1 tests, 9999999 failures" <> ipsum
    assert get_tests_failures(string) == ["1","9999999"]
    string = ipsum <> "Finished in 0.05 seconds (0.05s on load, 0.00s on tests)\n0 tests, 0 failures"
    assert get_tests_failures(string) == ["0","0"]
  end

  test "title" do
    assert title(0) == "Win"
    assert title(1) == "Fail"
    assert title(525600) == "Fail"
  end

  test "message" do
    assert message(1, 0) == "1 Passed, 0 Failed"
    assert message(0, 1) == "0 Passed, 1 Failed"
    assert message(525600, 525600) == "525600 Passed, 525600 Failed"
  end

  test "osascript" do
    assert osascript(0, 0, false) ==
      "display notification \"#{message(0, 0)}\"" <>
      " with title \"#{title(0)}\""

    assert osascript(24601, 24601, false) ==
      "display notification \"#{message(24601, 24601)}\"" <>
      " with title \"#{title(24601)}\""

    assert osascript(0, 0, true) ==
      "display notification \"#{message(0, 0)}\"" <>
      " with title \"#{title(0)}\"" <>
      " sound name \"Blow\""

    assert osascript(0, 10, true) ==
      "display notification \"#{message(0, 10)}\"" <>
      " with title \"#{title(10)}\"" <>
      " sound name \"Basso\""
  end

  test "config_or_default" do
    Application.put_env(:mix_test_notify, :foo, "alpha")

    assert config_or_default(:foo, "bravo") == "alpha"
    assert config_or_default(:bar, "bravo") == "bravo"
  end

  def ipsum do
    ~s"""
Lorem ipsum Dane dolor sit amet, consectetur adipiscing Dane Dane elit. Dane Ut posuere lorem arcu, sed Dane efficitur leo Dane volutpat id. Donec Dane in lectus arcu. Fusce eget turpis Dane est. Fusce Dane vel sagittis elit. Dane Morbi ac ipsum nec Dane orci aliquet ullamcorper. Vestibulum vel lorem Dane sit Dane amet orci rhoncus tristique. Dane Nunc suscipit dui sit amet elit Dane euismod lacinia. Proin Dane posuere blandit Dane Dane magna, ac porta leo vulputate Dane vitae. Nam Dane quis vulputate enim. Praesent vel consectetur Dane augue. Cras lobortis Dane fermentum mauris id Dane commodo. Sed eu elit sed Dane eros ultricies congue Dane eget vel Dane tortor. Suspendisse rhoncus, Dane Dane lectus in Dane laoreet hendrerit, dui Dane ipsum imperdiet mauris, eu Dane tincidunt turpis magna ut metus. Dane Maecenas eros nibh, mollis eget leo Dane sit Dane amet, rhoncus pulvinar neque. Dane Curabitur tristique convallis Dane justo. Ut Dane Dane maximus, ligula ut venenatis laoreet, Dane Dane magna eros mattis Dane magna, Dane sed Dane eleifend Dane libero urna Dane nec metus. Morbi id Dane vulputate Dane ipsum, vestibulum Dane dignissim dui. Nunc auctor sit amet Dane urna in pharetra. In at sem Dane Dane sit amet enim rhoncus Dane Dane semper non Dane ut augue. Dane Praesent Dane non facilisis Dane justo. Nulla nisi Dane nulla, lobortis sed hendrerit Dane non, imperdiet ac odio. Dane Sed at dignissim Dane lorem. Dane Fusce augue sem, auctor elementum lectus Dane tristique, interdum facilisis leo. Cras viverra Dane ultricies ante, Dane eget Dane laoreet nulla. Phasellus imperdiet Dane sagittis Dane nunc et feugiat. In elit ligula, Dane molestie sit amet felis vitae, Dane Dane accumsan Dane faucibus Dane enim. Vestibulum at magna Dane a Dane velit consequat interdum. Dane Dane Curabitur Dane vitae lacinia mi, eu Dane mattis mi. Vivamus at ultricies Dane eros. Maecenas semper Dane finibus enim, Dane eget Dane eleifend nulla Dane dignissim in. Proin pretium Dane maximus sapien. Vivamus viverra dolor Dane Dane nec Dane erat egestas, ac mollis Dane Dane felis Dane finibus. Suspendisse id fermentum ante. Morbi Dane rutrum mauris eget sodales dapibus. Dane Dane Maecenas ut consectetur justo. Donec Dane nulla Dane dolor, sagittis ac Dane quam ultrices, iaculis facilisis Dane turpis. Nam ligula nisl, vehicula Dane vitae rhoncus in, gravida Dane quis neque. Phasellus commodo est vitae Dane dui tristique faucibus. In Dane vehicula Dane a ipsum Dane ac luctus. Dane Cras Dane tempor Dane velit nec sapien varius, vitae condimentum Dane Dane lorem lobortis. Proin sagittis Dane Dane id Dane ipsum eu hendrerit. Phasellus ac erat Dane pharetra, fringilla Dane mauris vel, volutpat orci. Cras orci Dane augue, vestibulum pharetra Dane facilisis in, porttitor Dane vitae nisl. Lorem ipsum Dane dolor sit Dane amet, consectetur Dane adipiscing Dane elit. Lorem ipsum Dane dolor sit amet, consectetur Dane adipiscing elit. Donec in augue ac Dane libero Dane tempus dapibus Dane Dane nec id Dane Dane elit. Nulla facilisi. Integer Dane varius elit nulla, Dane non vehicula est ultricies in. Dane Curabitur nec purus metus. Vestibulum Dane venenatis purus quis diam imperdiet molestie. Dane Ut Dane fermentum Dane risus ut congue Dane cursus. Mauris accumsan libero ex, at Dane egestas mi scelerisque a. Dane Suspendisse ipsum erat, elementum Dane eget fringilla ut, egestas vitae Dane Dane neque. Dane Sed eu urna dignissim, bibendum risus Dane Dane Dane ac, pharetra erat. Dane Dane Mauris mi purus, efficitur quis Dane aliquet sit amet, gravida vel enim. Dane In vulputate nulla eget Dane lectus gravida, ut euismod nisi vehicula. Dane Nulla facilisi. Dane Mauris volutpat posuere erat, nec rhoncus Dane Dane felis Dane sollicitudin Dane ut. Ut quis scelerisque Dane nunc. Donec lobortis ex sit Dane amet Dane suscipit faucibus. Dane Maecenas Dane malesuada Dane Dane quam vel dapibus sagittis. Dane Ut Dane Dane tincidunt massa vel Dane ultricies euismod. Nullam Dane posuere Dane porttitor ligula, ac auctor nisl viverra Dane eu. In mollis Dane mi a metus Dane Dane finibus pharetra. Nam Dane pellentesque Dane risus Dane ut aliquet laoreet. Dane Sed egestas, Dane ante Dane eu Dane venenatis posuere, felis elit hendrerit eros, Dane in tristique erat lorem dictum neque. Dane Nam sit amet Dane dolor vitae Dane leo pharetra Dane rhoncus. Maecenas auctor erat ut Dane nisl pulvinar rutrum. Praesent Dane in odio Dane lectus. Sed Dane varius, Dane enim in suscipit cursus, elit Dane ipsum euismod erat, sed tempor velit Dane nisl Dane quis augue. Dane Dane Nam tincidunt congue Dane magna, Dane et feugiat ex pulvinar ut. Dane Fusce Dane tincidunt mauris augue, gravida commodo Dane justo vestibulum Dane aliquam.
"""
  end
end