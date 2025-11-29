defmodule CloudflareApi.RadarLeakedCredentialChecksTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarLeakedCredentialChecks

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "summary/3 hits summary path", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/radar/leaked_credential_checks/summary/bot_class"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"dimension" => "bot_class"}]}}}
    end)

    assert {:ok, [%{"dimension" => "bot_class"}]} =
             RadarLeakedCredentialChecks.summary(client, "bot_class")
  end

  test "timeseries_group/3 bubbles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 12}]}}}
    end)

    assert {:error, [%{"code" => 12}]} =
             RadarLeakedCredentialChecks.timeseries_group(client, "compromised")
  end
end
