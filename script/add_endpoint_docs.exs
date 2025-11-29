#!/usr/bin/env elixir

defmodule CloudflareApi.EndpointDoc do
  @moduledoc false

  require Macro

  def run([]) do
    Mix.shell().info(
      "No files provided. Usage: mix run script/add_endpoint_docs.exs path1 path2 ..."
    )
  end

  def run(files) do
    Enum.each(files, fn path ->
      inject(path)
    end)
  end

  defp inject(path) do
    content = File.read!(path)

    if module = module_name(content) do
      lines = String.split(content, "\n", trim: false)

      new_lines =
        Enum.flat_map(lines, fn line ->
          trimmed = String.trim_leading(line)

          if def_line?(trimmed) do
            case parse_signature(trimmed) do
              {name, args} ->
                build_doc_lines(module, line, name, args) ++ [line]

              nil ->
                [line]
            end
          else
            [line]
          end
        end)

      File.write!(path, Enum.join(new_lines, "\n"))
    end
  end

  defp module_name(content) do
    case Regex.run(~r/defmodule\s+([A-Za-z0-9_\.]+)/, content) do
      [_, module] -> module
      _ -> nil
    end
  end

  defp def_line?(trimmed), do: String.starts_with?(trimmed, "def ")

  defp parse_signature(line) do
    case Regex.run(~r/^def\s+([a-zA-Z0-9_?!]+)\s*(?:\(([^)]*)\))?/, line) do
      [_, name, args] -> {name, parse_args(args)}
      [_, name] -> {name, []}
      _ -> nil
    end
  end

  defp parse_args(nil), do: []

  defp parse_args(args) do
    args
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&split_default/1)
  end

  defp split_default(arg) do
    parts = String.split(arg, "\\\\", parts: 2)

    case parts do
      [name, default] -> {String.trim(name), String.trim(default)}
      [name] -> {String.trim(name), nil}
    end
  end

  defp build_doc_lines(module, line, name, args) do
    indent = leading_spaces(line)
    resource = resource_name(module)
    action = titleize(name)
    heading = heading(action, resource)
    example_result = example_result(name)
    args_sample = sample_arguments(args)

    [
      indent <> "@doc ~S\"\"\"",
      indent <> heading <> ".",
      indent,
      indent <> "Calls the Cloudflare API endpoint described in the moduledoc and",
      indent <>
        "returns `{:ok, result}` on success or `{:error, reason}` when the request fails.",
      indent,
      indent <> "## Examples",
      indent,
      indent <> "    iex> client = CloudflareApi.client(\"api-token\")",
      indent <> "    iex> " <> module <> "." <> name <> "(client" <> args_sample <> ")",
      indent <> "    {:ok, #{example_result}}",
      indent,
      indent <> "\"\"\"",
      ""
    ]
  end

  defp leading_spaces(line) do
    case Regex.run(~r/^(\s*)/, line) do
      [_, spaces] -> spaces
      _ -> ""
    end
  end

  defp resource_name(module) do
    module
    |> String.split(".")
    |> List.last()
    |> Macro.underscore()
    |> String.replace("_", " ")
  end

  defp titleize(name) do
    name
    |> String.trim_trailing("?")
    |> String.trim_trailing("!")
    |> String.replace("_", " ")
    |> String.capitalize()
  end

  defp heading(action, resource) do
    clean_resource = String.trim(resource)

    if String.contains?(action, " ") do
      String.trim("#{action} for #{clean_resource}")
    else
      String.trim("#{action} #{clean_resource}")
    end
  end

  defp sample_arguments(args) do
    args
    |> Enum.map(&build_argument/1)
    |> Enum.reject(&is_nil/1)
    |> case do
      [] -> ""
      samples -> ", " <> Enum.join(samples, ", ")
    end
  end

  defp build_argument({name, default}) do
    cond do
      name == "client" ->
        nil

      default && default != "" ->
        normalize_default(default)

      String.contains?(name, "opts") ->
        "[]"

      String.contains?(name, "params") ->
        "%{}"

      String.contains?(name, "body") ->
        "%{}"

      String.contains?(name, "data") ->
        "%{}"

      String.contains?(name, "config") ->
        "%{}"

      String.contains?(name, "settings") ->
        "%{}"

      String.contains?(name, "token") ->
        ~s("#{name}")

      String.contains?(name, "id") ->
        ~s("#{name}")

      String.contains?(name, "zone") ->
        ~s("#{name}")

      String.contains?(name, "account") ->
        ~s("#{name}")

      String.contains?(name, "host") ->
        ~s("#{name}")

      String.contains?(name, "domain") ->
        ~s("#{name}")

      String.contains?(name, "name") ->
        ~s("#{name}")

      Regex.match?(~r/(page|per_page|limit|count|ttl|port|size|since|until|start|end)/, name) ->
        "1"

      true ->
        ~s("#{name}")
    end
  end

  defp normalize_default(default) do
    clean = String.trim(default)

    cond do
      String.starts_with?(clean, "%{") -> "%{}"
      String.starts_with?(clean, "[") -> "[]"
      clean == "nil" -> "nil"
      true -> clean
    end
  end

  defp example_result(name) do
    if String.starts_with?(name, "list") or String.starts_with?(name, "get_all") do
      "[%{\"id\" => \"example\"}]"
    else
      "%{\"id\" => \"example\"}"
    end
  end
end

CloudflareApi.EndpointDoc.run(System.argv())
