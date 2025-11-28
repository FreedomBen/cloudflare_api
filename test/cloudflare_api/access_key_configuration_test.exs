defmodule CloudflareApi.AccessKeyConfigurationTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccessKeyConfiguration

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/2 hits keys endpoint", %{client: client} do
    mock(fn %Tesla.Env{
              method: :get,
              url: "https://api.cloudflare.com/client/v4/accounts/acc/access/keys"
            } = env ->
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"kid" => "123"}}}}
    end)

    assert {:ok, %{"kid" => "123"}} = AccessKeyConfiguration.get(client, "acc")
  end

  test "update/3 sends JSON body", %{client: client} do
    params = %{"kid" => "abc"}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = AccessKeyConfiguration.update(client, "acc", params)
  end

  test "rotate/2 posts empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/access/keys/rotate"
      assert body == "{}"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"rotated" => true}}}}
    end)

    assert {:ok, %{"rotated" => true}} = AccessKeyConfiguration.rotate(client, "acc")
  end
end
