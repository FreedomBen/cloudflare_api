defmodule CloudflareApi.CloudIntegrationsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.CloudIntegrations

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes filters", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/magic/cloud/providers?status=true&order_by=updated_at"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"id" => "provider"}]}
       }}
    end)

    assert {:ok, [_]} =
             CloudIntegrations.list(client, "acc", status: true, order_by: "updated_at")
  end

  test "create/4 sends JSON payload and headers", %{client: client} do
    params = %{"name" => "provider"}

    mock(fn %Tesla.Env{method: :post, headers: headers, body: body} = env ->
      assert {"forwarded", "value"} in headers
      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             CloudIntegrations.create(client, "acc", params, [{"forwarded", "value"}])
  end

  test "discover/4 posts with optional query", %{client: client} do
    mock(fn %Tesla.Env{url: url, method: :post} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/magic/cloud/providers/prov/discover?v2=true"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => %{"status" => "queued"}}
       }}
    end)

    assert {:ok, %{"status" => "queued"}} =
             CloudIntegrations.discover(client, "acc", "prov", v2: true)
  end

  test "update/4 propagates API errors", %{client: client} do
    mock(fn %Tesla.Env{method: :put, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/magic/cloud/providers/prov"

      {:ok,
       %Tesla.Env{
         env
         | status: 400,
           body: %{"errors" => [%{"code" => 6000, "message" => "invalid"}]}
       }}
    end)

    assert {:error, [%{"code" => 6000, "message" => "invalid"}]} =
             CloudIntegrations.update(client, "acc", "prov", %{})
  end
end
