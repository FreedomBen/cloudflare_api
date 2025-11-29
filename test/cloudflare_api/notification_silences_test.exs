defmodule CloudflareApi.NotificationSilencesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.NotificationSilences

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 requests silences collection", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/alerting/v3/silences?status=active"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "sil"}]}}}
    end)

    assert {:ok, [%{"id" => "sil"}]} = NotificationSilences.list(client, "acc", status: "active")
  end

  test "create/3 posts silence payload", %{client: client} do
    params = %{"name" => "Maintenance", "rules" => []}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = NotificationSilences.create(client, "acc", params)
  end

  test "update/3 handles API validation errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 422, body: %{"errors" => [%{"code" => 777}]}}}
    end)

    assert {:error, [%{"code" => 777}]} =
             NotificationSilences.update(client, "acc", %{"name" => "bad"})
  end

  test "get/3 hits silence detail endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/alerting/v3/silences/sil"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "sil"}}}}
    end)

    assert {:ok, %{"id" => "sil"}} = NotificationSilences.get(client, "acc", "sil")
  end

  test "delete/3 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} = NotificationSilences.delete(client, "acc", "sil")
  end
end
