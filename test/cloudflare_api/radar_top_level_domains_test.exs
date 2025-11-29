defmodule CloudflareApi.RadarTopLevelDomainsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarTopLevelDomains

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches tlds", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/tlds"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"tld" => "com"}]}}}
    end)

    assert {:ok, [%{"tld" => "com"}]} = RadarTopLevelDomains.list(client)
  end

  test "get/3 encodes tld", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/tlds/com"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"tld" => "com"}}}}
    end)

    assert {:ok, %{"tld" => "com"}} = RadarTopLevelDomains.get(client, "com")
  end

  test "get/3 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 22}]}}}
    end)

    assert {:error, [%{"code" => 22}]} = RadarTopLevelDomains.get(client, "bad")
  end
end
