defmodule CloudflareApi.IpAddressManagementLeasesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.IpAddressManagementLeases

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches leases", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/addressing/leases"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "lease"}]}}}
    end)

    assert {:ok, [%{"id" => "lease"}]} = IpAddressManagementLeases.list(client, "acc")
  end

  test "handle_response/1 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 1002}]}}}
    end)

    assert {:error, [%{"code" => 1002}]} = IpAddressManagementLeases.list(client, "acc")
  end
end
