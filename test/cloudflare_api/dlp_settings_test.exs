defmodule CloudflareApi.DlpSettingsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.DlpSettings

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "limits/2 fetches account limits", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/limits"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"datasets" => 5}}}}
    end)

    assert {:ok, %{"datasets" => 5}} = DlpSettings.limits(client, "acc")
  end

  test "validate_pattern/3 posts regex config", %{client: client} do
    params = %{"pattern" => "[0-9]+"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/patterns/validate"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"valid" => true}}}}
    end)

    assert {:ok, %{"valid" => true}} =
             DlpSettings.validate_pattern(client, "acc", params)
  end

  test "payload_log/2 returns current settings", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/payload_log"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"enabled" => true}}}}
    end)

    assert {:ok, %{"enabled" => true}} = DlpSettings.payload_log(client, "acc")
  end

  test "update_payload_log/3 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"message" => "bad"}]}}}
    end)

    assert {:error, [%{"message" => "bad"}]} =
             DlpSettings.update_payload_log(client, "acc", %{"enabled" => false})
  end
end
