defmodule GitPeer.Services.MixProject do
  use Mix.Project

  def project do
    [
      app: :services,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:git_cli, "~> 0.2.4"},
      {:gitex, "~> 0.2.0"},
      {:git_diff, "~> 0.3.0"},
      {:lasp, "~> 0.8.2"},
      {:logger_lager_backend, "~> 0.1.0"}
    ]
  end
end