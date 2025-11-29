defmodule CloudflareApi.NotificationPoliciesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.NotificationPolicies

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 fetches policies", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/alerting/v3/policies?per_page=50"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "pol"}]}}}
    end)

    assert {:ok, [%{"id" => "pol"}]} = NotificationPolicies.list(client, "acc", per_page: 50)
  end

  test "create/3 posts JSON body", %{client: client} do
    params = %{"name" => "Policy", "conditions" => []}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = NotificationPolicies.create(client, "acc", params)
  end

  test "update/4 bubbles validation errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 3000}]}}}
    end)

    assert {:error, [%{"code" => 3000}]} =
             NotificationPolicies.update(client, "acc", "pol", %{"name" => "bad"})
  end

  test "get/3 hits policy detail endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/alerting/v3/policies/pol"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "pol"}}}}
    end)

    assert {:ok, %{"id" => "pol"}} = NotificationPolicies.get(client, "acc", "pol")
  end

  test "delete/3 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} = NotificationPolicies.delete(client, "acc", "pol")
  end
end
