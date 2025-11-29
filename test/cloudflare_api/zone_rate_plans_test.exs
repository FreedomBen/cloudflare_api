defmodule CloudflareApi.ZoneRatePlansTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZoneRatePlans

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches available plans", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/zones/zone/available_rate_plans"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "free"}]}}}
    end)

    assert {:ok, [%{"id" => "free"}]} = ZoneRatePlans.list(client, "zone")
  end

  test "list/2 surfaces API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 403, body: %{"errors" => [%{"code" => 7000}]}}}
    end)

    assert {:error, [%{"code" => 7000}]} = ZoneRatePlans.list(client, "zone")
  end
end
