defmodule MixTestNotify.Mixfile do
  use Mix.Project

  def project do
    [app: :mix_test_notify,
     version: "0.1.1",
     elixir: "~> 1.2",
     description: description(),
     package: package(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:dogma, "~> 0.1", only: :dev},
      {:notifier, "~> 0.0.1"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description do
    "OSX notifications for mix test. Best when used with the most excellent mix test.watch."
  end

  defp package do
    [
      name: :mix_test_notify,
      maintainers: ["Adrian Dunston"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/apdunston/mix_test_notify"}
    ]
  end

end
