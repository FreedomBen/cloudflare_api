defmodule CloudflareApi.TokenValidationTokenRulesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.TokenValidationTokenRules

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 hits rules base", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/token_validation/rules?page=1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"value" => "allow"}]}}}
    end)

    assert {:ok, [%{"value" => "allow"}]} =
             TokenValidationTokenRules.list(client, "zone", page: 1)
  end

  test "create/3 posts payload", %{client: client} do
    params = %{"expression" => "http.request.uri.path contains \"/login\""}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             TokenValidationTokenRules.create(client, "zone", params)
  end

  test "preview/3 posts JSON", %{client: client} do
    params = %{"rules" => []}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert String.ends_with?(url, "/preview")
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"matches" => []}}}}
    end)

    assert {:ok, %{"matches" => []}} =
             TokenValidationTokenRules.preview(client, "zone", params)
  end

  test "update/delete handle errors", %{client: client} do
    params = %{"description" => "updated"}

    mock(fn
      %Tesla.Env{method: :patch, body: body} = env ->
        assert Jason.decode!(body) == params
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}

      %Tesla.Env{method: :delete} = env ->
        {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 77}]}}}
    end)

    assert {:ok, ^params} =
             TokenValidationTokenRules.update(client, "zone", "rule", params)

    assert {:error, [%{"code" => 77}]} =
             TokenValidationTokenRules.delete(client, "zone", "rule")
  end
end
