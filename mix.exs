defmodule Extruder.Mixfile do
  use Mix.Project

  def project do
    [app: :extruder,
     version: "0.0.1",
     elixir: "~> 1.2",
     package: package(),
     description: "Build elixir structs from untrusted sources",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     preferred_cli_env: [espec: :test]]
  end

  def application do
    [applications: [:logger, :timex]]
  end

  defp deps do
    [
      {:timex, "~> 3.1"},
      {:espec, "~> 0.8.18", only: :test}
    ]
  end

  defp package() do
    [
      files: ["lib", "mix.exs", "README.md"],
      maintainers: ["Eloy Gomez"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/eloy/extruder"}
    ]
  end
end
