defmodule CloudflareApi.LogcontrolCmbConfigTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.LogcontrolCmbConfig

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/2 fetches config", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/logs/control/cmb/config"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"enabled" => true}}}}
    end)

    assert {:ok, %{"enabled" => true}} = LogcontrolCmbConfig.get(client, "acc")
  end

  test "update/3 posts payload", %{client: client} do
    params = %{"enabled" => false}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = LogcontrolCmbConfig.update(client, "acc", params)
  end

  test "delete/2 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => nil}}}
    end)

    assert {:ok, nil} = LogcontrolCmbConfig.delete(client, "acc")
  end

  test "update/3 surfaces Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1234}]}}}
    end)

    assert {:error, [%{"code" => 1234}]} =
             LogcontrolCmbConfig.update(client, "acc", %{"enabled" => true})
  end
end
