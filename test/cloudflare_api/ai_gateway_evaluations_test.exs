defmodule CloudflareApi.AiGatewayEvaluationsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AiGatewayEvaluations

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_types/2 hits evaluation types", %{client: client} do
    mock(fn %Tesla.Env{
              method: :get,
              url: "https://api.cloudflare.com/client/v4/accounts/acc/ai-gateway/evaluation-types"
            } = env ->
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "manual"}]}}}
    end)

    assert {:ok, [%{"id" => "manual"}]} = AiGatewayEvaluations.list_types(client, "acc")
  end

  test "list/4 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/ai-gateway/gateways/gw/evaluations?page=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"name" => "eval"}]}}}
    end)

    assert {:ok, [%{"name" => "eval"}]} = AiGatewayEvaluations.list(client, "acc", "gw", page: 2)
  end

  test "create/4 sends JSON body and returns results", %{client: client} do
    params = %{"name" => "eval"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/ai-gateway/gateways/gw/evaluations"

      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "eval"}}}}
    end)

    assert {:ok, %{"name" => "eval"}} = AiGatewayEvaluations.create(client, "acc", "gw", params)
  end

  test "delete/4 normalises errors", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: _} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 1111}]}}}
    end)

    assert {:error, [%{"code" => 1111}]} = AiGatewayEvaluations.delete(client, "acc", "gw", "id")
  end
end
