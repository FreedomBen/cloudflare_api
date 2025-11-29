defmodule CloudflareApi.CloudflareImagesKeysTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.CloudflareImagesKeys

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches signing keys", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/images/v1/keys"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"name" => "key"}]}
       }}
    end)

    assert {:ok, [%{"name" => "key"}]} =
             CloudflareImagesKeys.list(client, "acc")
  end

  test "put/4 sends JSON body", %{client: client} do
    params = %{"pem" => "PEM"}

    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/images/v1/keys/key"

      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = CloudflareImagesKeys.put(client, "acc", "key", params)
  end

  test "delete/3 returns errors", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/images/v1/keys/key"

      {:ok,
       %Tesla.Env{
         env
         | status: 403,
           body: %{"errors" => [%{"code" => 9999, "message" => "forbidden"}]}
       }}
    end)

    assert {:error, [%{"code" => 9999, "message" => "forbidden"}]} =
             CloudflareImagesKeys.delete(client, "acc", "key")
  end
end
