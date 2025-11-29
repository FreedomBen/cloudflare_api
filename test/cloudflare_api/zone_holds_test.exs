defmodule CloudflareApi.ZoneHoldsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZoneHolds

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/2 fetches hold", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/zones/zone/hold"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"status" => "held"}}}}
    end)

    assert {:ok, %{"status" => "held"}} = ZoneHolds.get(client, "zone")
  end

  test "create/3 posts JSON", %{client: client} do
    params = %{"reason" => "audit"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert url(env) == "/zones/zone/hold"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = ZoneHolds.create(client, "zone", params)
  end

  test "delete/3 sends body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert url(env) == "/zones/zone/hold"
      assert Jason.decode!(body) == %{"reason" => "ok"}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} = ZoneHolds.delete(client, "zone", %{"reason" => "ok"})
  end

  test "patch/3 updates hold", %{client: client} do
    params = %{"status" => "released"}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert url(env) == "/zones/zone/hold"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = ZoneHolds.patch(client, "zone", params)
  end

  test "errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 99}]}}}
    end)

    assert {:error, [_]} = ZoneHolds.get(client, "zone")
  end

  defp url(%Tesla.Env{url: url}), do: String.replace_prefix(url, @base, "")
end
