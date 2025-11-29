defmodule CloudflareApi.IpIntelligenceTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.IpIntelligence

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get_overview/3 forwards query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/intel/ip?ip=1.1.1.1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"score" => 5}}}}
    end)

    assert {:ok, %{"score" => 5}} = IpIntelligence.get_overview(client, "acc", ip: "1.1.1.1")
  end

  test "handle_response/1 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 1002}]}}}
    end)

    assert {:error, [%{"code" => 1002}]} = IpIntelligence.get_overview(client, "acc")
  end
end
