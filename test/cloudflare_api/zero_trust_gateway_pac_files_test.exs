defmodule CloudflareApi.ZeroTrustGatewayPacFilesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZeroTrustGatewayPacFiles

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches pac files", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/gateway/pacfiles"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "pac"}]}}}
    end)

    assert {:ok, [_]} = ZeroTrustGatewayPacFiles.list(client, "acc")
  end

  test "create/3 posts JSON body", %{client: client} do
    params = %{"name" => "file"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert url(env) == "/accounts/acc/gateway/pacfiles"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ZeroTrustGatewayPacFiles.create(client, "acc", params)
  end

  test "errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 10}]}}}
    end)

    assert {:error, [_]} = ZeroTrustGatewayPacFiles.list(client, "acc")
  end

  defp url(%Tesla.Env{url: url}), do: String.replace_prefix(url, @base, "")
end
