defmodule CloudflareApi.DeviceDexTestsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.DeviceDexTests

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches device dex tests", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dex/devices/dex_tests"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "test"}]}}}
    end)

    assert {:ok, [_]} = DeviceDexTests.list(client, "acc")
  end

  test "create/3 posts JSON body", %{client: client} do
    params = %{"name" => "test"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "test"}}}}
    end)

    assert {:ok, %{"id" => "test"}} = DeviceDexTests.create(client, "acc", params)
  end

  test "get/3 retrieves test details", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dex/devices/dex_tests/test"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "test"}}}}
    end)

    assert {:ok, %{"id" => "test"}} = DeviceDexTests.get(client, "acc", "test")
  end

  test "update/4 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 422, body: %{"errors" => [%{"code" => 99}]}}}
    end)

    assert {:error, [%{"code" => 99}]} =
             DeviceDexTests.update(client, "acc", "test", %{"name" => "new"})
  end

  test "delete/3 sends empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} = DeviceDexTests.delete(client, "acc", "test")
  end
end
