defmodule CloudflareApi.CnisTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Cnis

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 forwards query opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cni/cnis?slot=edge&tunnel_id=tun&limit=2"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"id" => "cni"}]}
       }}
    end)

    assert {:ok, [%{"id" => "cni"}]} =
             Cnis.list(client, "acc", slot: "edge", tunnel_id: "tun", limit: 2)
  end

  test "create/3 sends JSON payload", %{client: client} do
    params = %{"interconnect" => "ic", "account" => %{}, "magic" => %{}}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/cni/cnis"
      assert Jason.decode!(body) == params

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => params}
       }}
    end)

    assert {:ok, ^params} = Cnis.create(client, "acc", params)
  end

  test "update/4 sends JSON and handles errors", %{client: client} do
    mock(fn %Tesla.Env{method: :put, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cni/cnis/cni"

      {:ok,
       %Tesla.Env{
         env
         | status: 400,
           body: %{"errors" => [%{"code" => 123, "message" => "invalid"}]}
       }}
    end)

    assert {:error, [%{"code" => 123, "message" => "invalid"}]} =
             Cnis.update(client, "acc", "cni", %{})
  end

  test "delete/3 hits correct endpoint", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cni/cnis/cni"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => %{"id" => "cni"}}
       }}
    end)

    assert {:ok, %{"id" => "cni"}} = Cnis.delete(client, "acc", "cni")
  end
end
