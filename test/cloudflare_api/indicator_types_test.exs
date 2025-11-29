defmodule CloudflareApi.IndicatorTypesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.IndicatorTypes

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 fetches indicator types", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/indicator-types"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"type" => "domain"}]}}}
    end)

    assert {:ok, [%{"type" => "domain"}]} = IndicatorTypes.list(client, "acc")
  end

  test "list_legacy/3 hits legacy path", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/indicatorTypes"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = IndicatorTypes.list_legacy(client, "acc")
  end

  test "create/4 posts new type payload", %{client: client} do
    params = %{"indicatorType" => "URL"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = IndicatorTypes.create(client, "acc", "ds", params)
  end

  test "handle_response/1 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1002}]}}}
    end)

    assert {:error, [%{"code" => 1002}]} = IndicatorTypes.list(client, "acc")
  end
end
