defmodule CloudflareApi.ApiShieldWafExpressionTemplatesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ApiShieldWafExpressionTemplates

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "upsert_fallthrough/3 posts params", %{client: client} do
    params = %{"expression" => "ip.src eq 1.1.1.1"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/api_gateway/expression-template/fallthrough"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ApiShieldWafExpressionTemplates.upsert_fallthrough(client, "zone", params)
  end
end
