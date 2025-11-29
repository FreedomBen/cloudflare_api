defmodule CloudflareApi.UserApiTokensTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.UserApiTokens

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 includes query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/user/tokens?per_page=5"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "tok"}]}}}
    end)

    assert {:ok, [%{"id" => "tok"}]} = UserApiTokens.list(client, per_page: 5)
  end

  test "create/2 posts JSON", %{client: client} do
    params = %{"name" => "deploy"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = UserApiTokens.create(client, params)
  end

  test "permission_groups/2 hits endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert String.ends_with?(url, "/permission_groups")
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = UserApiTokens.permission_groups(client)
  end

  test "update/delete/roll_token work", %{client: client} do
    params = %{"name" => "new"}

    mock(fn
      %Tesla.Env{method: :put, url: url, body: body} = env ->
        assert String.ends_with?(url, "/user/tokens/token")
        assert Jason.decode!(body) == params
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}

      %Tesla.Env{method: :delete} = env ->
        {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 36}]}}}
    end)

    assert {:ok, ^params} = UserApiTokens.update(client, "token", params)
    assert {:error, [%{"code" => 36}]} = UserApiTokens.delete(client, "token")
  end

  test "roll_token/3 posts default body", %{client: client} do
    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert String.ends_with?(url, "/value")
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"value" => "xxx"}}}}
    end)

    assert {:ok, %{"value" => "xxx"}} = UserApiTokens.roll_token(client, "token")
  end
end
