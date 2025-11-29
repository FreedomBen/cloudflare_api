defmodule CloudflareApi.AccountRequestTracerTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccountRequestTracer

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "trace/3 posts payload", %{client: client} do
    params = %{"path" => "/"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/request-tracer/trace"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"trace_id" => "tid"}}}}
    end)

    assert {:ok, %{"trace_id" => "tid"}} = AccountRequestTracer.trace(client, "acc", params)
  end
end
