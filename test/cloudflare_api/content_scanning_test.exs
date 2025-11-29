defmodule CloudflareApi.ContentScanningTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ContentScanning

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "enable/2 hits enable endpoint", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/content-upload-scan/enable"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"value" => "enabled"}}}}
    end)

    assert {:ok, %{"value" => "enabled"}} = ContentScanning.enable(client, "zone")
  end

  test "update_settings/3 sends JSON payload", %{client: client} do
    params = %{"value" => "disabled"}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ContentScanning.update_settings(client, "zone", params)
  end

  test "add_payloads/3 posts array body", %{client: client} do
    payloads = [%{"payload" => "pattern"}]

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == payloads

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => payloads}}}
    end)

    assert {:ok, ^payloads} =
             ContentScanning.add_payloads(client, "zone", payloads)
  end
end
