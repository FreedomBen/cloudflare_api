defmodule CloudflareApi.WorkerEnvironmentTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WorkerEnvironment

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get_content/4 hits the content path", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/workers/services/svc/environments/prod/content"

      {:ok, %Tesla.Env{env | status: 200, body: "export default { }"}}
    end)

    assert {:ok, "export default { }"} =
             WorkerEnvironment.get_content(client, "acc", "svc", "prod")
  end

  test "put_content/5 forwards multipart body and headers", %{client: client} do
    body =
      Tesla.Multipart.new()
      |> Tesla.Multipart.add_field("metadata", ~s({"main_module":"worker.js"}))

    headers = [{"CF-WORKER-BODY-PART", "worker.js"}]

    mock(fn %Tesla.Env{method: :put, url: url, body: req_body, headers: req_headers} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/workers/services/svc/environments/prod/content"

      assert req_body == body
      assert {"CF-WORKER-BODY-PART", "worker.js"} in req_headers
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "script"}}}}
    end)

    assert {:ok, %{"id" => "script"}} =
             WorkerEnvironment.put_content(client, "acc", "svc", "prod", body, headers)
  end

  test "get_settings/4 reads settings path", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/workers/services/svc/environments/prod/settings"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"logpush" => true}}}}
    end)

    assert {:ok, %{"logpush" => true}} =
             WorkerEnvironment.get_settings(client, "acc", "svc", "prod")
  end

  test "patch_settings/5 encodes JSON body", %{client: client} do
    params = %{"logpush" => false}

    mock(fn %Tesla.Env{method: :patch, url: url, body: body} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/workers/services/svc/environments/prod/settings"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             WorkerEnvironment.patch_settings(client, "acc", "svc", "prod", params)
  end

  test "returns API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 9}]}}}
    end)

    assert {:error, [%{"code" => 9}]} =
             WorkerEnvironment.get_settings(client, "acc", "svc", "prod")
  end
end
