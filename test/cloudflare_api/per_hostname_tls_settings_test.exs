defmodule CloudflareApi.PerHostnameTlsSettingsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.PerHostnameTlsSettings

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/4 hits setting collection", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/hostnames/settings/tls13?per_page=20"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"hostname" => "a"}]}}}
    end)

    assert {:ok, [%{"hostname" => "a"}]} =
             PerHostnameTlsSettings.list(client, "zone", "tls13", per_page: 20)
  end

  test "put_hostname/5 encodes hostname in path", %{client: client} do
    params = %{"value" => "on"}
    encoded = URI.encode_www_form("blog.example.com")

    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/hostnames/settings/tls13/#{encoded}"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             PerHostnameTlsSettings.put_hostname(
               client,
               "zone",
               "tls13",
               "blog.example.com",
               params
             )
  end

  test "delete_hostname/4 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} =
             PerHostnameTlsSettings.delete_hostname(client, "zone", "tls13", "blog")
  end

  test "get_hostname/4 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 999}]}}}
    end)

    assert {:error, [%{"code" => 999}]} =
             PerHostnameTlsSettings.get_hostname(client, "zone", "tls13", "bad")
  end
end
