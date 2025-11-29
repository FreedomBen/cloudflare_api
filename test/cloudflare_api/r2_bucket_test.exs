defmodule CloudflareApi.R2BucketTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.R2Bucket

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 fetches buckets", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/r2/buckets"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"name" => "bucket"}]}}}
    end)

    assert {:ok, [%{"name" => "bucket"}]} = R2Bucket.list(client, "acc")
  end

  test "put_cors/4 issues PUT", %{client: client} do
    params = %{"cors_rules" => []}

    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/r2/buckets/foo/cors"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = R2Bucket.put_cors(client, "acc", "foo", params)
  end

  test "update_custom_domain/5 encodes domain", %{client: client} do
    params = %{"status" => "enabled"}
    encoded = URI.encode_www_form("cdn.example.com")

    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/r2/buckets/foo/domains/custom/#{encoded}"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, %{"status" => "enabled"}} =
             R2Bucket.update_custom_domain(client, "acc", "foo", "cdn.example.com", params)
  end

  test "update_event_notification/5 hits event notification path", %{client: client} do
    params = %{"filters" => []}

    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/event_notifications/r2/foo/configuration/queues/bar"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, %{"filters" => []}} =
             R2Bucket.update_event_notification(client, "acc", "foo", "bar", params)
  end

  test "create_temp_credentials/3 posts request", %{client: client} do
    params = %{"bucket" => "foo"}

    mock(fn %Tesla.Env{method: :post, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/r2/temp-access-credentials"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"key" => "abc"}}}}
    end)

    assert {:ok, %{"key" => "abc"}} = R2Bucket.create_temp_credentials(client, "acc", params)
  end

  test "get/3 propagates API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 404}]}}}
    end)

    assert {:error, [%{"code" => 404}]} = R2Bucket.get(client, "acc", "missing")
  end
end
