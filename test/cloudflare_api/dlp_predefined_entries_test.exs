defmodule CloudflareApi.DlpPredefinedEntriesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.DlpPredefinedEntries

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "create/3 posts predefined entry", %{client: client} do
    params = %{"entry_id" => "pci"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/entries/predefined"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "pci"}}}}
    end)

    assert {:ok, %{"id" => "pci"}} =
             DlpPredefinedEntries.create(client, "acc", params)
  end

  test "delete/3 sends empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} =
             DlpPredefinedEntries.delete(client, "acc", "pci")
  end
end
