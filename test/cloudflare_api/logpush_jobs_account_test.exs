defmodule CloudflareApi.LogpushJobsAccountTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.LogpushJobsAccount

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches account jobs", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/logpush/jobs"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = LogpushJobsAccount.list(client, "acc")
  end

  test "validate_origin/3 posts params", %{client: client} do
    params = %{"url" => "https://example.com"}

    mock(fn %Tesla.Env{method: :post, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/logpush/validate/origin"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"success" => true}}}}
    end)

    assert {:ok, %{"success" => true}} =
             LogpushJobsAccount.validate_origin(client, "acc", params)
  end

  test "update/4 surfaces Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 7000}]}}}
    end)

    assert {:error, [%{"code" => 7000}]} =
             LogpushJobsAccount.update(client, "acc", 10, %{"enabled" => true})
  end
end
