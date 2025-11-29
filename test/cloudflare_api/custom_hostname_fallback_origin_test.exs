defmodule CloudflareApi.CustomHostnameFallbackOriginTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.CustomHostnameFallbackOrigin

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/2 fetches fallback origin", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/custom_hostnames/fallback_origin"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => %{"origin" => "origin.example.com"}}
       }}
    end)

    assert {:ok, %{"origin" => "origin.example.com"}} =
             CustomHostnameFallbackOrigin.get(client, "zone")
  end

  test "update/3 sends JSON payload", %{client: client} do
    params = %{"origin" => "fallback.example.com"}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             CustomHostnameFallbackOrigin.update(client, "zone", params)
  end

  test "delete/2 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{method: :delete} = env ->
      {:ok,
       %Tesla.Env{
         env
         | status: 404,
           body: %{"errors" => [%{"code" => 404, "message" => "not found"}]}
       }}
    end)

    assert {:error, [%{"code" => 404, "message" => "not found"}]} =
             CustomHostnameFallbackOrigin.delete(client, "zone")
  end
end
