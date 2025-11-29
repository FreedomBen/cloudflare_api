defmodule CloudflareApi.WafPackagesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WafPackages

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 fetches packages", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/firewall/waf/packages?per_page=5"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "pkg"}]}}}
    end)

    assert {:ok, [%{"id" => "pkg"}]} = WafPackages.list(client, "zone", per_page: 5)
  end

  test "update/4 patches payload", %{client: client} do
    params = %{"sensitivity" => "low"}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = WafPackages.update(client, "zone", "pkg", params)
  end
end
