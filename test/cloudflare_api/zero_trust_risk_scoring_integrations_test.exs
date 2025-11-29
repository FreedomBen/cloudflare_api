defmodule CloudflareApi.ZeroTrustRiskScoringIntegrationsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZeroTrustRiskScoringIntegrations

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches integrations", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/zt_risk_scoring/integrations"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = ZeroTrustRiskScoringIntegrations.list(client, "acc")
  end

  test "create/3 posts JSON", %{client: client} do
    params = %{"name" => "integration"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert url(env) == "/accounts/acc/zt_risk_scoring/integrations"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ZeroTrustRiskScoringIntegrations.create(client, "acc", params)
  end

  test "get_by_reference_id/3 hits reference path", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/zt_risk_scoring/integrations/reference_id/ref"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"reference_id" => "ref"}}}}
    end)

    assert {:ok, %{"reference_id" => "ref"}} =
             ZeroTrustRiskScoringIntegrations.get_by_reference_id(client, "acc", "ref")
  end

  test "delete/3 issues empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url, body: body} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/zt_risk_scoring/integrations/int%2F1"

      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             ZeroTrustRiskScoringIntegrations.delete(client, "acc", "int/1")
  end

  test "get/3 fetches integration", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/zt_risk_scoring/integrations/int%2F1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "int/1"}}}}
    end)

    assert {:ok, %{"id" => "int/1"}} =
             ZeroTrustRiskScoringIntegrations.get(client, "acc", "int/1")
  end

  test "update/4 puts JSON", %{client: client} do
    params = %{"name" => "updated"}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert url(env) ==
               "/accounts/acc/zt_risk_scoring/integrations/int"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ZeroTrustRiskScoringIntegrations.update(client, "acc", "int", params)
  end

  test "errors propagate", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 5}]}}}
    end)

    assert {:error, [_]} = ZeroTrustRiskScoringIntegrations.list(client, "acc")
  end

  defp url(%Tesla.Env{url: url}), do: String.replace_prefix(url, @base, "")
end
