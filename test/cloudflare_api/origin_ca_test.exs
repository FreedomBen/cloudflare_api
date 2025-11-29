defmodule CloudflareApi.OriginCaTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.OriginCa

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 applies query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/certificates?status=active"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "cert"}]}}}
    end)

    assert {:ok, [%{"id" => "cert"}]} = OriginCa.list(client, status: "active")
  end

  test "create/2 posts JSON body", %{client: client} do
    params = %{"hostnames" => ["example.com"]}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = OriginCa.create(client, params)
  end

  test "revoke/2 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"revoked" => true}}}}
    end)

    assert {:ok, %{"revoked" => true}} = OriginCa.revoke(client, "id")
  end

  test "get/2 propagates API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 900}]}}}
    end)

    assert {:error, [%{"code" => 900}]} = OriginCa.get(client, "missing")
  end
end
