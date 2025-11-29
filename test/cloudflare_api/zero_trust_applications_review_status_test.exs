defmodule CloudflareApi.ZeroTrustApplicationsReviewStatusTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZeroTrustApplicationsReviewStatus

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/2 fetches review status", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/gateway/apps/review_status"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"status" => "pending"}}}}
    end)

    assert {:ok, %{"status" => "pending"}} =
             ZeroTrustApplicationsReviewStatus.get(client, "acc")
  end

  test "update/3 sends JSON body", %{client: client} do
    params = %{"status" => "approved"}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert url(env) == "/accounts/acc/gateway/apps/review_status"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ZeroTrustApplicationsReviewStatus.update(client, "acc", params)
  end

  test "errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 5}]}}}
    end)

    assert {:error, [_]} =
             ZeroTrustApplicationsReviewStatus.get(client, "acc")
  end

  defp url(%Tesla.Env{url: url}), do: String.replace_prefix(url, @base, "")
end
