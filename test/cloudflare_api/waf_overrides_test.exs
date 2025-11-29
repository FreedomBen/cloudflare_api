defmodule CloudflareApi.WafOverridesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WafOverrides

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 hits overrides endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/firewall/waf/overrides?page=1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "ov"}]}}}
    end)

    assert {:ok, [%{"id" => "ov"}]} = WafOverrides.list(client, "zone", page: 1)
  end

  test "create/3 posts JSON", %{client: client} do
    params = %{"rules" => []}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = WafOverrides.create(client, "zone", params)
  end

  test "delete/3 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 7006}]}}}
    end)

    assert {:error, [%{"code" => 7006}]} = WafOverrides.delete(client, "zone", "ov")
  end
end
