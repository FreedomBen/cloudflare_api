defmodule CloudflareApi.SslVerificationTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.SslVerification

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "details/3 hits verification endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/ssl/verification"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"status" => "pending"}}}}
    end)

    assert {:ok, %{"status" => "pending"}} = SslVerification.details(client, "zone")
  end

  test "update_pack_method/4 patches pack", %{client: client} do
    params = %{"validation_method" => "email"}

    mock(fn %Tesla.Env{method: :patch, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/ssl/verification/pack"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = SslVerification.update_pack_method(client, "zone", "pack", params)
  end

  test "details/3 returns errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 3}]}}}
    end)

    assert {:error, [%{"code" => 3}]} = SslVerification.details(client, "zone")
  end
end
