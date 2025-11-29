defmodule CloudflareApi.WafRulesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WafRules

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/4 hits rules endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/firewall/waf/packages/pkg/rules?page=1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "rule"}]}}}
    end)

    assert {:ok, [%{"id" => "rule"}]} =
             WafRules.list(client, "zone", "pkg", page: 1)
  end

  test "update/5 patches payload", %{client: client} do
    params = %{"mode" => "simulate"}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = WafRules.update(client, "zone", "pkg", "rule", params)
  end
end
