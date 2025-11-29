defmodule CloudflareApi.TelemetryQueryTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.TelemetryQuery

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "run/3 posts query payload", %{client: client} do
    params = %{"query" => "SELECT *"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/workers/observability/telemetry/query"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"rows" => 1}]}}}
    end)

    assert {:ok, [%{"rows" => 1}]} = TelemetryQuery.run(client, "acc", params)
  end

  test "run/3 bubbles Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 422, body: %{"errors" => [%{"code" => 12}]}}}
    end)

    assert {:error, [%{"code" => 12}]} = TelemetryQuery.run(client, "acc", %{"query" => "bad"})
  end
end
