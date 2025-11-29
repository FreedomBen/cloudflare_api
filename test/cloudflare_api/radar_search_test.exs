defmodule CloudflareApi.RadarSearchTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarSearch

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "global/2 encodes query", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/search/global?q=cloudflare"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"name" => "Cloudflare"}]}}}
    end)

    assert {:ok, [%{"name" => "Cloudflare"}]} = RadarSearch.global(client, q: "cloudflare")
  end

  test "global/2 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 6}]}}}
    end)

    assert {:error, [%{"code" => 6}]} = RadarSearch.global(client)
  end
end
