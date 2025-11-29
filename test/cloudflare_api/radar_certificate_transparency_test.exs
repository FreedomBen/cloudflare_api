defmodule CloudflareApi.RadarCertificateTransparencyTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarCertificateTransparency, as: RadarCt

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "authorities/2 fetches authorities", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/ct/authorities"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"slug" => "letsencrypt"}]}}}
    end)

    assert {:ok, [%{"slug" => "letsencrypt"}]} = RadarCt.authorities(client)
  end

  test "summary/3 encodes dimension", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/ct/summary/tld"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"dimension" => "tld"}]}}}
    end)

    assert {:ok, [%{"dimension" => "tld"}]} = RadarCt.summary(client, "tld")
  end

  test "log/3 returns errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 77}]}}}
    end)

    assert {:error, [%{"code" => 77}]} = RadarCt.log(client, "missing")
  end
end
