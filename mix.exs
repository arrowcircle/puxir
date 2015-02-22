defmodule Puxir.Mixfile do
  use Mix.Project

  def project do
    [app: :puxir,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    dev_apps = Mix.env == :dev && [:reprise] || []
    [
      applications: dev_apps ++ [:logger, :cowboy, :gproc],
      mod: {Puxir, []}
    ]
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
      { :cowboy, "~> 1.0.0" },
      { :exjsx, "~> 3.1.0" },
      { :gproc, "~> 0.3.1" },
      { :uuid, "~> 0.1.5" },
      { :reprise, "~> 0.3.0", only: :dev }
    ]
  end
end
