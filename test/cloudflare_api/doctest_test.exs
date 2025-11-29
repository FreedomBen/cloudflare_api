defmodule CloudflareApi.DoctestTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  @modules (fn ->
              _ = Application.load(:cloudflare_api)

              :cloudflare_api
              |> Application.spec(:modules)
              |> List.wrap()
              |> Enum.filter(&(Atom.to_string(&1) |> String.starts_with?("Elixir.CloudflareApi")))
              |> Enum.sort()
            end).()

  @list_exceptions [
    "CloudflareApi.DosFlowtrackdApi.get_allowlist_prefix",
    "CloudflareApi.EmailSecuritySettings.get_allow_policy",
    "CloudflareApi.ZoneSettings.get_all"
  ]

  @raw_body_tests [
    "CloudflareApi.InfrastructureAccessTargets.get_loa",
    "CloudflareApi.Interconnects.get_loa",
    "CloudflareApi.CloudflareIps.list"
  ]

  setup context do
    if context[:test_type] == :doctest do
      mock(fn env ->
        result = sample_result(context[:test])

        {:ok,
         %Tesla.Env{
           env
           | status: 200,
             body: response_body(context[:test], result)
         }}
      end)
    end

    :ok
  end

  for module <- @modules do
    doctest module
  end

  defp sample_result(nil), do: %{"id" => "example"}

  defp sample_result(test_name) do
    name = Atom.to_string(test_name)

    if list_test?(name) do
      [%{"id" => "example"}]
    else
      %{"id" => "example"}
    end
  end

  defp list_test?(name) do
    String.contains?(name, ".list") ||
      Enum.any?(@list_exceptions, &String.contains?(name, &1))
  end

  defp response_body(nil, result), do: %{"result" => result}

  defp response_body(test_name, result) do
    name = Atom.to_string(test_name)

    if Enum.any?(@raw_body_tests, &String.contains?(name, &1)) do
      result
    else
      %{"result" => result}
    end
  end
end
