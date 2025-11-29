defmodule CloudflareApi.InstantLogsJobsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.InstantLogsJobs

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 hits Instant Logs endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/logpush/edge/jobs"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = InstantLogsJobs.list(client, "zone")
  end

  test "create/3 posts job payload", %{client: client} do
    params = %{"fields" => ["ClientIP"]}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = InstantLogsJobs.create(client, "zone", params)
  end

  test "handle_response/1 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1002}]}}}
    end)

    assert {:error, [%{"code" => 1002}]} = InstantLogsJobs.list(client, "zone")
  end
end
