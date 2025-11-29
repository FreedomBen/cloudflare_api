defmodule CloudflareApi.CallsAppsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.CallsApps

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches apps", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/calls/apps"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"id" => "app"}]}
       }}
    end)

    assert {:ok, [%{"id" => "app"}]} = CallsApps.list(client, "acc")
  end

  test "create/3 sends JSON payload", %{client: client} do
    params = %{"name" => "Call App"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/calls/apps"
      assert Jason.decode!(body) == params

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => params}
       }}
    end)

    assert {:ok, ^params} = CallsApps.create(client, "acc", params)
  end

  test "delete/3 bubbles up errors", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/calls/apps/app"

      {:ok,
       %Tesla.Env{
         env
         | status: 404,
           body: %{"errors" => [%{"code" => 4040, "message" => "not found"}]}
       }}
    end)

    assert {:error, [%{"code" => 4040, "message" => "not found"}]} =
             CallsApps.delete(client, "acc", "app")
  end
end
