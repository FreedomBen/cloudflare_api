defmodule CloudflareApi.SecondaryDnsTsigTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.SecondaryDnsTsig

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 fetches TSIGs", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/secondary_dns/tsigs"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "tsig"}]}}}
    end)

    assert {:ok, [%{"id" => "tsig"}]} = SecondaryDnsTsig.list(client, "acc")
  end

  test "create/3 posts TSIG definition", %{client: client} do
    params = %{"name" => "peer", "secret" => "base64=="}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = SecondaryDnsTsig.create(client, "acc", params)
  end

  test "update/4 sends PUT body", %{client: client} do
    params = %{"secret" => "other"}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = SecondaryDnsTsig.update(client, "acc", "tsig-id", params)
  end

  test "delete/3 returns errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 55}]}}}
    end)

    assert {:error, [%{"code" => 55}]} = SecondaryDnsTsig.delete(client, "acc", "tsig-id")
  end
end
