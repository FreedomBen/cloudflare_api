defmodule CloudflareApi.DnsInternalViewsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.DnsInternalViews

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches internal views", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dns_settings/views"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "view"}]}}}
    end)

    assert {:ok, [_]} = DnsInternalViews.list(client, "acc")
  end

  test "create/3 posts JSON", %{client: client} do
    params = %{"name" => "internal"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "view"}}}}
    end)

    assert {:ok, %{"id" => "view"}} = DnsInternalViews.create(client, "acc", params)
  end

  test "get/3 retrieves details", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dns_settings/views/view"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "view"}}}}
    end)

    assert {:ok, %{"id" => "view"}} = DnsInternalViews.get(client, "acc", "view")
  end

  test "update/4 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"message" => "bad"}]}}}
    end)

    assert {:error, [%{"message" => "bad"}]} =
             DnsInternalViews.update(client, "acc", "view", %{"name" => "new"})
  end

  test "delete/3 sends empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} =
             DnsInternalViews.delete(client, "acc", "view")
  end
end
