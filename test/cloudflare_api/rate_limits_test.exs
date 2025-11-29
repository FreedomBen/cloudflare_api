defmodule CloudflareApi.RateLimitsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RateLimits

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/rate_limits?page=1"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "rl"}]}}}
    end)

    assert {:ok, [%{"id" => "rl"}]} = RateLimits.list(client, "zone", page: 1)
  end

  test "create/3 posts payload", %{client: client} do
    params = %{"description" => "test"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = RateLimits.create(client, "zone", params)
  end

  test "delete/3 sends empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} = RateLimits.delete(client, "zone", "rl")
  end

  test "get/3 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 44}]}}}
    end)

    assert {:error, [%{"code" => 44}]} = RateLimits.get(client, "zone", "missing")
  end
end
