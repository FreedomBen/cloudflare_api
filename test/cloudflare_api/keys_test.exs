defmodule CloudflareApi.KeysTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Keys

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 posts filters and returns keys", %{client: client} do
    params = %{"datasets" => ["workers"], "limit" => 5}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/workers/observability/telemetry/keys"

      assert Jason.decode!(body) == params

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{
             "result" => [
               %{"key" => "request.cf.asn", "type" => "string", "lastSeenAt" => 1_707_000_000}
             ]
           }
       }}
    end)

    assert {:ok, [%{"key" => "request.cf.asn"}]} = Keys.list(client, "acc", params)
  end

  test "list/3 surfaces Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1002}]}}}
    end)

    assert {:error, [%{"code" => 1002}]} = Keys.list(client, "acc")
  end
end
