defmodule CloudflareApi.TotalTlsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.TotalTls

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/2 fetches settings", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/acm/total_tls"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"enabled" => true}}}}
    end)

    assert {:ok, %{"enabled" => true}} = TotalTls.get(client, "zone")
  end

  test "update/3 posts payload", %{client: client} do
    params = %{"enabled" => false}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = TotalTls.update(client, "zone", params)
  end
end
