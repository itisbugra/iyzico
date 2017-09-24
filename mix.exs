defmodule Iyzico.Mixfile do
  use Mix.Project

  def project do
    [app: :iyzico,
     version: "1.5.2",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     test_coverage: [tool: ExCoveralls],
     package: [
       name: :iyzico,
       maintainers: ["Buğra Ekuklu", "Abdulkadir Dilsiz"],
       licenses: ["MIT"],
       links: %{github: "https://github.com/chatatata/iyzico"}
     ],
     description: """
     A minimal iyzico Client for Elixir.
     """]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:dev), do: ["lib", "docs"]
  defp elixirc_paths(_),     do: ["lib"]

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:poison, "~> 3.1"},
     {:luhn, "~> 0.3.1"},
     {:ex_doc, ">= 0.0.0", only: :dev},
     {:excoveralls, "~> 0.7.2", only: :test},
     {:inch_ex, only: :docs}]
  end
end
