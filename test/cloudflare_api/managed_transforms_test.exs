defmodule CloudflareApi.ManagedTransformsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ManagedTransforms

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches managed transforms", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/managed_headers"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "mt"}]}}}
    end)

    assert {:ok, [%{"id" => "mt"}]} = ManagedTransforms.list(client, "zone")
  end

  test "update/3 sends patch body", %{client: client} do
    params = %{"managed_request_headers" => [%{"status" => "enabled"}]}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = ManagedTransforms.update(client, "zone", params)
  end

  test "delete/2 returns :no_content", %{client: client} do
    mock(fn %Tesla.Env{method: :delete} = env ->
      {:ok, %Tesla.Env{env | status: 204}}
    end)

    assert {:ok, :no_content} = ManagedTransforms.delete(client, "zone")
  end
end
