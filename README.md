MixTestNotify
=============

OSX notifications for `mix test`. Best when used with the most excellent [mix test.watch](https://github.com/lpil/mix-test.watch).

# Requirements

You must have OSX Mavericks or beyond.

# Usage

Add it to your dependencies

```elixir
# mix.exs
def deps do
  [{:mix_test_notify, path: "path/to/mix_test_notify", only: :dev}]
end
```

Enjoy!
```
mix test.notify
```

## Mix Test.Watch
https://github.com/lpil/mix-test.watch
This runs tests in the background. Use the two together for maximum goodness.

```elixir
# mix.exs

def deps do
  [
    {:mix_test_notify, path: "path/to/mix_test_notify"},
    {:mix_test_watch, "~> 0.2", only: :dev}
  ]
end
```

```elixir
# config.exs
config :mix_test_watch, tasks: ["test.notify"]
```

```
mix deps.get
```

```
mix test.watch
```

## Optional Configuration

```elixir
mix.exs

config :mix_test_notify, :sound, true
config :mix_test_notify, :win_sound, "Blow"
config :mix_test_notify, :fail_sound, "Basso"
config :mix_test_notify, :win_title, "Win"
config :mix_test_notify, :fail_title, "Fail"
```
Available sounds are `Basso`, `Blow`, `Bottle`, `Frog`, `Funk`, `Glass`, `Hero`, `Morse`, `Ping`, `Pop`, `Purr`, `Sosumi`, `Submarine`, `Tink`, or anything in `~/Library/Sounds`

# License
```
MIT License

Copyright (c) 2016 Adrian P. Dunston I

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
