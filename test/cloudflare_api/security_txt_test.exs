defmodule CloudflareApi.SecurityTxtTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.SecurityTxt

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/2 fetches the document", %{client: client} do
    mock(fn %Tesla.Env{method: :get} = env ->
      assert url(env) == "/zones/zone/security-center/securitytxt"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"enabled" => true}}}}
    end)

    assert {:ok, %{"enabled" => true}} = SecurityTxt.get(client, "zone")
  end

  test "update/3 puts JSON", %{client: client} do
    payload = %{"enabled" => true, "contact" => ["mailto:security@example.com"]}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert url(env) == "/zones/zone/security-center/securitytxt"
      assert Jason.decode!(body) == payload
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => payload}}}
    end)

    assert {:ok, ^payload} = SecurityTxt.update(client, "zone", payload)
  end

  test "delete/2 removes document", %{client: client} do
    mock(fn %Tesla.Env{method: :delete} = env ->
      assert url(env) == "/zones/zone/security-center/securitytxt"
      {:ok, %Tesla.Env{env | status: 200, body: %{"success" => true}}}
    end)

    assert {:ok, %{"success" => true}} = SecurityTxt.delete(client, "zone")
  end

  test "errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 1003}]}}}
    end)

    assert {:error, [_]} = SecurityTxt.get(client, "zone")
  end

  defp url(%Tesla.Env{url: url}), do: String.replace_prefix(url, @base, "")
end
