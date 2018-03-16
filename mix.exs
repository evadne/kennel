defmodule Collab.Mixfile do
  use Mix.Project

  def project do
    [
      app: :kennel,
      version: "0.0.1",
      elixir: ">= 1.4.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: Mix.compilers,
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps(),
      dialyzer: dialyzer()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Kennel, []},
      applications: applications_list()
    ]
  end

  defp applications_list() do
    [
      :inets,
      :logger,
      :erlexec,
      :exexec,
      :hackney,
      :poison
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["app", "lib", "test/support"]
  defp elixirc_paths(_),     do: ["app", "lib"]

  defp deps do
    [
      {:exexec, "~> 0.0.1"},
      {:hound, "~> 1.0.1"}
    ]
  end

  defp dialyzer do
    [
      ignore_warnings: "dialyzer.ignore-warnings",
      plt_add_apps: [:mix, :mnesia, :iex],
      plt_add_deps: :transitive,
      flags: [
        "-Werror_handling",
        "-Wno_opaque",
        "-Woverspecs",
        "-Wrace_conditions",
        "-Wunderspecs",
        "-Wunmatched_returns"
      ]
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases, do: []
end
