defmodule CloudflareApi.EndpointHealthChecksTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.EndpointHealthChecks

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes pagination options", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/diagnostics/endpoint-healthchecks?page=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "hc"}]}}}
    end)

    assert {:ok, [_]} = EndpointHealthChecks.list(client, "acc", page: 2)
  end

  test "create/3 posts JSON body", %{client: client} do
    params = %{"name" => "check"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "hc"}}}}
    end)

    assert {:ok, %{"id" => "hc"}} = EndpointHealthChecks.create(client, "acc", params)
  end

  test "get/3 retrieves check", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/diagnostics/endpoint-healthchecks/hc"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "hc"}}}}
    end)

    assert {:ok, %{"id" => "hc"}} =
             EndpointHealthChecks.get(client, "acc", "hc")
  end

  test "update/4 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 422, body: %{"errors" => [%{"code" => 1}]}}}
    end)

    assert {:error, [%{"code" => 1}]} =
             EndpointHealthChecks.update(client, "acc", "hc", %{"name" => "new"})
  end

  test "delete/3 sends empty JSON", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} =
             EndpointHealthChecks.delete(client, "acc", "hc")
  end
end
