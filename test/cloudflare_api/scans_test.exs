defmodule CloudflareApi.ScansTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Scans

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get_config/3 fetches config", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/scans/config"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"configs" => []}}}}
    end)

    assert {:ok, %{"configs" => []}} = Scans.get_config(client, "acc")
  end

  test "create_config/3 posts params", %{client: client} do
    params = %{"targets" => ["1.2.3.4"]}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "cfg"}}}}
    end)

    assert {:ok, %{"id" => "cfg"}} = Scans.create_config(client, "acc", params)
  end

  test "open_ports/4 encodes config id", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/scans/results/cfg"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = Scans.open_ports(client, "acc", "cfg")
  end

  test "delete_config/3 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 11}]}}}
    end)

    assert {:error, [%{"code" => 11}]} = Scans.delete_config(client, "acc", "cfg")
  end
end
