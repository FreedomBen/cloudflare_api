#!/usr/bin/env elixir

Mix.install([])

defmodule UpdateVersion do
  @root Path.expand("..", __DIR__)
  @mix Path.join(@root, "mix.exs")
  @readme Path.join(@root, "README.md")
  @claude Path.join(@root, "CLAUDE.md")
  @changelog Path.join(@root, "CHANGELOG.md")

  def run([]) do
    IO.puts("v" <> current_version())
  end

  def run([arg]) do
    version = parse_version(arg)
    current = current_version()

    if version == current do
      IO.puts("Version already #{version}")
      System.halt(0)
    end

    update_mix(version)
    update_readme(version)
    update_claude(version)
    update_changelog(version)

    IO.puts("Updated version #{current} -> #{version}")
  end

  def run(_args) do
    abort!("Usage: script/update_version.exs [vMAJOR.MINOR.PATCH]")
  end

  defp parse_version(arg) do
    case Regex.run(~r/^v?(\d+\.\d+\.\d+)$/, arg) do
      [_, version] -> version
      _ -> abort!("Invalid version #{inspect(arg)}. Expected v0.0.0")
    end
  end

  defp current_version do
    case Regex.run(~r/@version\s+"([^"]+)"/, File.read!(@mix)) do
      [_, version] -> version
      _ -> abort!("Unable to locate @version in mix.exs")
    end
  end

  defp update_mix(version) do
    replace(@mix, fn contents ->
      String.replace(contents, ~r/@version\s+"([^"]+)"/, ~s/@version "#{version}"/, global: false)
    end)
  end

  defp update_readme(version) do
    replace(@readme, fn contents ->
      Regex.replace(
        ~r/{:cloudflare_api,\s*"~>\s*[^"]+"}/,
        contents,
        ~s/{:cloudflare_api, "~> #{version}"}/,
        global: false
      )
    end)
  end

  defp update_claude(version) do
    replace(@claude, fn contents ->
      String.replace(contents, ~r/Current version:\s+[0-9.]+/, "Current version: #{version}", global: false)
    end)
  end

  defp update_changelog(version) do
    contents = File.read!(@changelog)

    {before, rest} =
      case String.split(contents, "## [unreleased]\n", parts: 2) do
        [b, r] -> {String.trim_trailing(b), r}
        _ -> abort!("Unable to locate '## [unreleased]' in CHANGELOG.md")
      end

    {unreleased_body, tail} =
      case String.split(rest, "\n## [", parts: 2) do
        [body, remaining] -> {String.trim_trailing(body), "\n## [" <> remaining}
        [body] -> {String.trim_trailing(body), ""}
      end

    release_body =
      case String.trim(unreleased_body) do
        "" -> "- _Nothing yet_"
        other -> other
      end

    release_section = """
    ## [#{version}] - #{Date.utc_today() |> Date.to_iso8601()}

    #{release_body}
    """
    |> String.trim_trailing()

    new_unreleased = """
    ## [unreleased]

    ### Added

    - _Nothing yet_

    ### Changed

    - _Nothing yet_

    ### Fixed

    - _Nothing yet_
    """
    |> String.trim_trailing()

    new_contents =
      [before, new_unreleased, release_section, tail]
      |> Enum.reject(&(&1 == ""))
      |> Enum.join("\n\n")

    File.write!(@changelog, new_contents <> "\n")
  end

  defp replace(path, fun) do
    path
    |> File.read!()
    |> fun.()
    |> then(&File.write!(path, &1))
  end

  defp abort!(message) do
    IO.puts(:stderr, message)
    System.halt(1)
  end
end

UpdateVersion.run(System.argv())
