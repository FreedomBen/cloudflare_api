defmodule CloudflareApi.LoadBalancerHealthcheckEventsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.LoadBalancerHealthcheckEvents

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 encodes filters", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      %URI{path: path, query: query} = URI.parse(url)
      assert path == "/client/v4/user/load_balancing_analytics/events"

      assert URI.decode_query(query) == %{
               "pool_id" => "abc",
               "origin_name" => "edge-1"
             }

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => 1}]}}}
    end)

    assert {:ok, [_]} =
             LoadBalancerHealthcheckEvents.list(client,
               pool_id: "abc",
               origin_name: "edge-1"
             )
  end

  test "list/2 surfaces Cloudflare error payloads", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 2001}]}}}
    end)

    assert {:error, [%{"code" => 2001}]} = LoadBalancerHealthcheckEvents.list(client)
  end
end
