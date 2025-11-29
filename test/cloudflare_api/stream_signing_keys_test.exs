defmodule CloudflareApi.StreamSigningKeysTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.StreamSigningKeys

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches keys", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/stream/keys"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "key"}]}}}
    end)

    assert {:ok, [%{"id" => "key"}]} = StreamSigningKeys.list(client, "acc")
  end

  test "create/2 posts empty map by default", %{client: client} do
    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "new"}}}}
    end)

    assert {:ok, %{"id" => "new"}} = StreamSigningKeys.create(client, "acc")
  end

  test "delete/3 returns errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 9004}]}}}
    end)

    assert {:error, [%{"code" => 9004}]} = StreamSigningKeys.delete(client, "acc", "missing")
  end
end
