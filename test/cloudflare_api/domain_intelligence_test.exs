defmodule CloudflareApi.DomainIntelligenceTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.DomainIntelligence

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/3 fetches domain details", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/intel/domain?domain=example.com"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"domain" => "example.com"}}}}
    end)

    assert {:ok, %{"domain" => "example.com"}} =
             DomainIntelligence.get(client, "acc", domain: "example.com")
  end

  test "bulk_get/3 hits bulk endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/intel/domain/bulk?domain=example.com&domain=foo.com"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"domain" => "example.com"}]}}}
    end)

    assert {:ok, [_]} =
             DomainIntelligence.bulk_get(client, "acc", domain: ["example.com", "foo.com"])
  end

  test "get/3 surfaces Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1}]}}}
    end)

    assert {:error, [%{"code" => 1}]} =
             DomainIntelligence.get(client, "acc", domain: "bad")
  end
end
