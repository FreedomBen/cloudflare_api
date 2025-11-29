defmodule CloudflareApi.OriginPostQuantumTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.OriginPostQuantum

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/2 retrieves setting", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/cache/origin_post_quantum_encryption"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"value" => "on"}}}}
    end)

    assert {:ok, %{"value" => "on"}} = OriginPostQuantum.get(client, "zone")
  end

  test "update/3 PUTs payload", %{client: client} do
    params = %{"value" => "off"}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = OriginPostQuantum.update(client, "zone", params)
  end

  test "update/3 returns errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1}]}}}
    end)

    assert {:error, [%{"code" => 1}]} = OriginPostQuantum.update(client, "zone", %{"value" => "bad"})
  end
end
