defmodule CloudflareApi.NotificationDestinationsPagerdutyTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.NotificationDestinationsPagerduty

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_services/3 lists PagerDuty services", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/alerting/v3/destinations/pagerduty"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => ["svc"]}}}
    end)

    assert {:ok, ["svc"]} = NotificationDestinationsPagerduty.list_services(client, "acc")
  end

  test "delete_services/3 sends JSON body", %{client: client} do
    params = %{"service_ids" => ["svc"]}

    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} =
             NotificationDestinationsPagerduty.delete_services(client, "acc", params)
  end

  test "create_connect_token/3 posts connect payload", %{client: client} do
    params = %{"redirect_url" => "https://example.com"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/alerting/v3/destinations/pagerduty/connect"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"token_id" => "tok"}}}}
    end)

    assert {:ok, %{"token_id" => "tok"}} =
             NotificationDestinationsPagerduty.create_connect_token(client, "acc", params)
  end

  test "get_connect_token/3 bubbles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 4040}]}}}
    end)

    assert {:error, [%{"code" => 4040}]} =
             NotificationDestinationsPagerduty.get_connect_token(client, "acc", "tok")
  end
end
