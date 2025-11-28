defmodule CloudflareApi.AiGatewayDatasetsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AiGatewayDatasets

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/4 encodes query params", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/ai-gateway/gateways/gw/datasets?per_page=10"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "ds"}]}}}
    end)

    assert {:ok, [%{"id" => "ds"}]} = AiGatewayDatasets.list(client, "acc", "gw", per_page: 10)
  end

  test "create/4 passes body and normalises errors", %{client: client} do
    params = %{"name" => "dataset"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/ai-gateway/gateways/gw/datasets"

      assert Jason.decode!(body) == params

      {:ok,
       %Tesla.Env{
         env
         | status: 400,
           body: %{"errors" => [%{"code" => 1000}]}
       }}
    end)

    assert {:error, [%{"code" => 1000}]} = AiGatewayDatasets.create(client, "acc", "gw", params)
  end
end
