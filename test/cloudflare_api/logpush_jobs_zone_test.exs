defmodule CloudflareApi.LogpushJobsZoneTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.LogpushJobsZone

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches zone jobs", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/logpush/jobs"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = LogpushJobsZone.list(client, "zone")
  end

  test "create/3 posts job payload", %{client: client} do
    params = %{"dataset" => "http_requests", "destination_conf" => "s3://bucket/prefix"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = LogpushJobsZone.create(client, "zone", params)
  end

  test "list_dataset_fields/3 hits dataset endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/logpush/datasets/http_requests/fields"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"field" => "desc"}}}}
    end)

    assert {:ok, %{"field" => "desc"}} =
             LogpushJobsZone.list_dataset_fields(client, "zone", "http_requests")
  end

  test "ownership_challenge/3 posts params", %{client: client} do
    params = %{"destination_conf" => "s3://bucket"}

    mock(fn %Tesla.Env{method: :post, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/logpush/ownership"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"filename" => "cf.txt"}}}}
    end)

    assert {:ok, %{"filename" => "cf.txt"}} =
             LogpushJobsZone.ownership_challenge(client, "zone", params)
  end

  test "validate_destination/3 posts destination details", %{client: client} do
    params = %{"destination_conf" => "gcs://bucket"}

    mock(fn %Tesla.Env{method: :post, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/logpush/validate/destination"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"valid" => true}}}}
    end)

    assert {:ok, %{"valid" => true}} =
             LogpushJobsZone.validate_destination(client, "zone", params)
  end

  test "destination_exists?/3 handles Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 6100}]}}}
    end)

    assert {:error, [%{"code" => 6100}]} =
             LogpushJobsZone.destination_exists?(client, "zone", %{"destination_conf" => "s3://"})
  end

  test "delete/3 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/logpush/jobs/100"
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => 100}}}}
    end)

    assert {:ok, %{"id" => 100}} = LogpushJobsZone.delete(client, "zone", 100)
  end
end
