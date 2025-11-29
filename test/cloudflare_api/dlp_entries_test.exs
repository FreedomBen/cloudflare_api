defmodule CloudflareApi.DlpEntriesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.DlpEntries

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches entries", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/entries"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "entry"}]}}}
    end)

    assert {:ok, [_]} = DlpEntries.list(client, "acc")
  end

  test "create/3 posts JSON", %{client: client} do
    params = %{"name" => "entry"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "entry"}}}}
    end)

    assert {:ok, %{"id" => "entry"}} = DlpEntries.create(client, "acc", params)
  end

  test "get/3 retrieves entry", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/entries/id"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "id"}}}}
    end)

    assert {:ok, %{"id" => "id"}} = DlpEntries.get(client, "acc", "id")
  end

  test "update/4 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1}]}}}
    end)

    assert {:error, [%{"code" => 1}]} =
             DlpEntries.update(client, "acc", "id", %{"name" => "x"})
  end

  test "update_custom_entry/4 posts JSON", %{client: client} do
    params = %{"value" => "a"}

    mock(fn %Tesla.Env{url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/entries/custom/id"

      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"updated" => true}}}}
    end)

    assert {:ok, %{"updated" => true}} =
             DlpEntries.update_custom_entry(client, "acc", "id", params)
  end

  test "update_predefined_entry/4 posts JSON", %{client: client} do
    mock(fn %Tesla.Env{url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/entries/predefined/id"

      assert Jason.decode!(body) == %{"enabled" => true}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             DlpEntries.update_predefined_entry(client, "acc", "id", %{"enabled" => true})
  end

  test "delete/3 sends empty object body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} = DlpEntries.delete(client, "acc", "id")
  end
end
