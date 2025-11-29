defmodule CloudflareApi.ValuesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Values

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 posts telemetry query", %{client: client} do
    params = %{"component" => "worker"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/workers/observability/telemetry/values"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"value" => 1}]}}}
    end)

    assert {:ok, [%{"value" => 1}]} = Values.list(client, "acc", params)
  end
end
