defmodule CloudflareApi.ZeroTrustRiskScoringTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZeroTrustRiskScoring

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_behaviors/2 fetches behaviors", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/zt_risk_scoring/behaviors"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = ZeroTrustRiskScoring.list_behaviors(client, "acc")
  end

  test "update_behaviors/3 sends JSON", %{client: client} do
    params = %{"severity" => "high"}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert url(env) == "/accounts/acc/zt_risk_scoring/behaviors"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ZeroTrustRiskScoring.update_behaviors(client, "acc", params)
  end

  test "summary/2 fetches account summary", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/zt_risk_scoring/summary"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} = ZeroTrustRiskScoring.summary(client, "acc")
  end

  test "user_summary/3 fetches user summary", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/zt_risk_scoring/user%401"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"user" => "user@1"}}}}
    end)

    assert {:ok, %{"user" => "user@1"}} =
             ZeroTrustRiskScoring.user_summary(client, "acc", "user@1")
  end

  test "reset_user/4 posts body", %{client: client} do
    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert url(env) ==
               "/accounts/acc/zt_risk_scoring/user/reset"

      assert Jason.decode!(body) == %{"reason" => "manual"}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             ZeroTrustRiskScoring.reset_user(client, "acc", "user", %{"reason" => "manual"})
  end

  test "errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 4}]}}}
    end)

    assert {:error, [_]} =
             ZeroTrustRiskScoring.user_summary(client, "acc", "missing")
  end

  defp url(%Tesla.Env{url: url}), do: String.replace_prefix(url, @base, "")
end
