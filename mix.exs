defmodule CloudflareApi.MixProject do
  use Mix.Project

  @source_url "https://github.com/freedomben/cloudflare_api"
  @version "0.4.1"

  def project do
    [
      app: :cloudflare_api,
      version: @version,
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      description: "A set of convenience functions around the Cloudflare Client API",
      package: package(),
      deps: deps(),
      docs: docs(),
      aliases: aliases(),
      dialyzer: dialyzer()
    ]
  end

  def package do
    [
      name: "cloudflare_api",
      maintainers: ["Benjmain Porter"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {CloudflareApi.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.39.1"},
      {:tesla, "~> 1.4"},
      {:hackney, "~> 1.17"},
      {:jason, "~> 1.4"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:number, "~> 1.0.3"}
    ]
  end

  defp aliases do
    [
      fetch_openapi: ["cloudflare_api.fetch_openapi"],
      update_version: ["run script/update_version.exs"]
    ]
  end

  defp docs do
    [
      main: "CloudflareApi",
      source_url: @source_url,
      extra_section: [],
      api_reference: false
    ]
  end

  defp dialyzer do
    [
      plt_add_apps: [:mix, :iex]
    ]
  end
end
