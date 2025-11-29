defmodule CloudflareApi.IpAddressManagementDynamicAdvertisementTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.IpAddressManagementDynamicAdvertisement

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get_status/3 fetches advertisement state", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/addressing/prefixes/pref/bgp/status"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"advertised" => true}}}}
    end)

    assert {:ok, %{"advertised" => true}} =
             IpAddressManagementDynamicAdvertisement.get_status(client, "acc", "pref")
  end

  test "update_status/4 patches advertised flag", %{client: client} do
    params = %{"advertised" => false}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             IpAddressManagementDynamicAdvertisement.update_status(client, "acc", "pref", params)
  end

  test "handle_response/1 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 1002}]}}}
    end)

    assert {:error, [%{"code" => 1002}]} =
             IpAddressManagementDynamicAdvertisement.get_status(client, "acc", "pref")
  end
end
