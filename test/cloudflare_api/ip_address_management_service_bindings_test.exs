defmodule CloudflareApi.IpAddressManagementServiceBindingsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.IpAddressManagementServiceBindings

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 hits bindings path", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/addressing/prefixes/pfx/bindings"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = IpAddressManagementServiceBindings.list(client, "acc", "pfx")
  end

  test "create/4 posts payload", %{client: client} do
    params = %{"service_id" => "svc", "description" => "binding"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             IpAddressManagementServiceBindings.create(client, "acc", "pfx", params)
  end

  test "delete/4 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "binding"}}}}
    end)

    assert {:ok, %{"id" => "binding"}} =
             IpAddressManagementServiceBindings.delete(client, "acc", "pfx", "binding")
  end

  test "list_services/2 hits services endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/addressing/services"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = IpAddressManagementServiceBindings.list_services(client, "acc")
  end

  test "handle_response/1 surfaces API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1002}]}}}
    end)

    assert {:error, [%{"code" => 1002}]} =
             IpAddressManagementServiceBindings.list(client, "acc", "pfx")
  end
end
