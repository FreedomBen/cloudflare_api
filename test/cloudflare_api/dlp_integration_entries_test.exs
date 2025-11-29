defmodule CloudflareApi.DlpIntegrationEntriesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.DlpIntegrationEntries

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "create/3 posts integration entry", %{client: client} do
    params = %{"name" => "int"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/entries/integration"

      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "int"}}}}
    end)

    assert {:ok, %{"id" => "int"}} =
             DlpIntegrationEntries.create(client, "acc", params)
  end

  test "update/4 posts JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/entries/integration/id"

      assert Jason.decode!(body) == %{"name" => "updated"}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             DlpIntegrationEntries.update(client, "acc", "id", %{"name" => "updated"})
  end

  test "delete/3 propagates errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok,
       %Tesla.Env{
         env
         | status: 404,
           body: %{"errors" => [%{"message" => "not found"}]}
       }}
    end)

    assert {:error, [%{"message" => "not found"}]} =
             DlpIntegrationEntries.delete(client, "acc", "missing")
  end
end
