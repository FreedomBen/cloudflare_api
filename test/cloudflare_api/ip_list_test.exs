defmodule CloudflareApi.IpListTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.IpList

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 fetches IP lists", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/intel/ip-list"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"name" => "Blocks"}]}}}
    end)

    assert {:ok, [%{"name" => "Blocks"}]} = IpList.list(client, "acc")
  end

  test "list/3 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 1002}]}}}
    end)

    assert {:error, [%{"code" => 1002}]} = IpList.list(client, "acc")
  end
end
