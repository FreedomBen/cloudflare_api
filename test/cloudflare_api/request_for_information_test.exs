defmodule CloudflareApi.RequestForInformationTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RequestForInformation, as: RFI

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 posts filters", %{client: client} do
    params = %{"status" => "open"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/requests"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "req"}]}}}
    end)

    assert {:ok, [%{"id" => "req"}]} = RFI.list(client, "acc", params)
  end

  test "constants/2 hits constants endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/requests/constants"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"types" => []}}}}
    end)

    assert {:ok, %{"types" => []}} = RFI.constants(client, "acc")
  end

  test "create_asset/4 posts payload", %{client: client} do
    params = %{"name" => "doc"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/requests/req/asset/new"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "asset"}}}}
    end)

    assert {:ok, %{"id" => "asset"}} = RFI.create_asset(client, "acc", "req", params)
  end

  test "delete_message/5 sends empty JSON", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} =
             RFI.delete_message(client, "acc", "req", "msg")
  end

  test "get/3 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 101}]}}}
    end)

    assert {:error, [%{"code" => 101}]} = RFI.get(client, "acc", "missing")
  end
end
