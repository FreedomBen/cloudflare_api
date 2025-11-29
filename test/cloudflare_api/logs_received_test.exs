defmodule CloudflareApi.LogsReceivedTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.LogsReceived

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get_retention_flag/2 fetches flag", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/logs/control/retention/flag"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"value" => "on"}}}}
    end)

    assert {:ok, %{"value" => "on"}} = LogsReceived.get_retention_flag(client, "zone")
  end

  test "update_retention_flag/3 posts params", %{client: client} do
    params = %{"value" => "off"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = LogsReceived.update_retention_flag(client, "zone", params)
  end

  test "list/3 encodes query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      %URI{path: path, query: query} = URI.parse(url)
      assert path == "/client/v4/zones/zone/logs/received"

      assert URI.decode_query(query) == %{
               "start" => "2024-01-01T10:00:00Z",
               "end" => "2024-01-01T10:01:00Z",
               "fields" => "RayID"
             }

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => "log lines"}}}
    end)

    assert {:ok, "log lines"} =
             LogsReceived.list(client, "zone",
               start: "2024-01-01T10:00:00Z",
               end: "2024-01-01T10:01:00Z",
               fields: "RayID"
             )
  end

  test "get_ray_ids/4 handles Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 2042}]}}}
    end)

    assert {:error, [%{"code" => 2042}]} =
             LogsReceived.get_ray_ids(client, "zone", "abcd", fields: "RayID")
  end
end
