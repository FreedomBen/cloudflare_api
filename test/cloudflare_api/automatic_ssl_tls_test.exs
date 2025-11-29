defmodule CloudflareApi.AutomaticSslTlsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AutomaticSslTls

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/2 fetches automatic mode setting", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/settings/ssl_automatic_mode"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => %{"id" => "ssl_automatic_mode", "value" => "auto"}}
       }}
    end)

    assert {:ok, %{"value" => "auto"}} = AutomaticSslTls.get(client, "zone")
  end

  test "patch/3 sends JSON body and surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{method: :patch, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/settings/ssl_automatic_mode"

      assert Jason.decode!(body) == %{"value" => "custom"}

      {:ok,
       %Tesla.Env{
         env
         | status: 400,
           body: %{"errors" => [%{"code" => 1008, "message" => "invalid value"}]}
       }}
    end)

    assert {:error, [%{"code" => 1008, "message" => "invalid value"}]} =
             AutomaticSslTls.patch(client, "zone", %{"value" => "custom"})
  end
end
