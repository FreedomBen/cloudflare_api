defmodule CloudflareApi.AsnIntelligenceTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AsnIntelligence

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get_overview/3 hits ASN endpoint", %{client: client} do
    mock(fn %Tesla.Env{
              method: :get,
              url: "https://api.cloudflare.com/client/v4/accounts/acc/intel/asn/1337"
            } = env ->
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"asn" => "1337"}}}}
    end)

    assert {:ok, %{"asn" => "1337"}} = AsnIntelligence.get_overview(client, "acc", 1337)
  end

  test "list_subnets/4 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/intel/asn/1337/subnets?per_page=5"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"cidr" => "1.1.1.0/24"}]}}}
    end)

    assert {:ok, [_]} =
             AsnIntelligence.list_subnets(client, "acc", 1337, per_page: 5)
  end
end
