defmodule Spotify.Mixfile do
  use Mix.Project

  def project do
    [app: :spotify_ex,
     version: "2.0.2",
     elixir: "~> 1.3",
     description: description,
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     source_url: "https://github.com/jsncmgs1/spotify_ex",
     homepage_url: "https://github.com/jsncmgs1/spotify_ex",
     deps: deps,
     docs: [extras: ["README.md"]]
   ]
  end

  defp package do
    [
      maintainers: ["Jason Cummings"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://www.github.com/jsncmgs1/spotify_ex",
               "Example Phoenix App" => "https://www.github.com/jsncmgs1/spotify_ex_test"}
    ]
  end
  defp description do
    """
    An Elixir wrapper for the Spotify Web API.
    """
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison, :poison, :plug]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 0.9.0"},
      {:poison, ">= 1.5.0"},
      {:plug, "~> 1.2.0"},
      {:mock, "~> 0.1.1", only: :test},
      {:ex_doc, "~> 0.2", only: :dev},
      {:inch_ex, ">= 0.0.0", only: :docs}
    ]
  end
end
