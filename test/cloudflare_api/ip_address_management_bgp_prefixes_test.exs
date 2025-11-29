defmodule CloudflareApi.IpAddressManagementBgpPrefixesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.IpAddressManagementBgpPrefixes

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 hits BGP prefixes path", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/addressing/prefixes/prefix/bgp/prefixes"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = IpAddressManagementBgpPrefixes.list(client, "acc", "prefix")
  end

  test "create/4 posts schema payload", %{client: client} do
    params = %{"cidr" => "203.0.113.0/24"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             IpAddressManagementBgpPrefixes.create(client, "acc", "prefix", params)
  end

  test "update/5 patches advertisement settings", %{client: client} do
    params = %{"advertised" => true}

    mock(fn %Tesla.Env{method: :patch, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/addressing/prefixes/prefix/bgp/prefixes/bgp"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             IpAddressManagementBgpPrefixes.update(client, "acc", "prefix", "bgp", params)
  end

  test "delete/4 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "bgp"}}}}
    end)

    assert {:ok, %{"id" => "bgp"}} =
             IpAddressManagementBgpPrefixes.delete(client, "acc", "prefix", "bgp")
  end

  test "handle_response/1 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1002}]}}}
    end)

    assert {:error, [%{"code" => 1002}]} =
             IpAddressManagementBgpPrefixes.list(client, "acc", "prefix")
  end
end
