defmodule CloudflareApi.LivestreamAnalyticsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.LivestreamAnalytics

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "daywise/4 adds time filters", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      %URI{path: path, query: query} = URI.parse(url)

      assert path ==
               "/client/v4/accounts/acc/realtime/kit/app/analytics/livestreams/daywise"

      assert URI.decode_query(query) == %{
               "start_time" => "2024-01-01T00:00:00Z",
               "end_time" => "2024-01-07T00:00:00Z"
             }

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"days" => []}}}}
    end)

    assert {:ok, %{"days" => []}} =
             LivestreamAnalytics.daywise(client, "acc", "app",
               start_time: "2024-01-01T00:00:00Z",
               end_time: "2024-01-07T00:00:00Z"
             )
  end

  test "overall/4 handles Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/realtime/kit/app/analytics/livestreams/overall"

      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"message" => "bad"}]}}}
    end)

    assert {:error, [%{"message" => "bad"}]} =
             LivestreamAnalytics.overall(client, "acc", "app")
  end
end
