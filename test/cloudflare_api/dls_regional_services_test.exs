defmodule CloudflareApi.DlsRegionalServicesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.DlsRegionalServices

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_regions/2 hits account endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/addressing/regional_hostnames/regions"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "eu"}]}}}
    end)

    assert {:ok, [%{"id" => "eu"}]} = DlsRegionalServices.list_regions(client, "acc")
  end

  test "list_hostnames/2 fetches zone hostnames", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/addressing/regional_hostnames"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"hostname" => "www"}]}}}
    end)

    assert {:ok, [_]} = DlsRegionalServices.list_hostnames(client, "zone")
  end

  test "create_hostname/3 posts JSON body", %{client: client} do
    params = %{"hostname" => "www", "region_key" => "eu"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             DlsRegionalServices.create_hostname(client, "zone", params)
  end

  test "get_hostname/3 fetches hostname", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/addressing/regional_hostnames/www"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"hostname" => "www"}}}}
    end)

    assert {:ok, %{"hostname" => "www"}} =
             DlsRegionalServices.get_hostname(client, "zone", "www")
  end

  test "update_hostname/4 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 422, body: %{"errors" => [%{"message" => "bad"}]}}}
    end)

    assert {:error, [%{"message" => "bad"}]} =
             DlsRegionalServices.update_hostname(client, "zone", "www", %{"region_key" => "us"})
  end

  test "delete_hostname/3 sends empty object body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} =
             DlsRegionalServices.delete_hostname(client, "zone", "www")
  end
end
