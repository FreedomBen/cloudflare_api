defmodule CloudflareApi.ZeroTrustUsersTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZeroTrustUsers

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes filters", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/access/users?email=user%40example.com&page=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} =
             ZeroTrustUsers.list(client, "acc", email: "user@example.com", page: 2)
  end

  test "list_active_sessions/3 fetches sessions", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/access/users/user%401/active_sessions"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} =
             ZeroTrustUsers.list_active_sessions(client, "acc", "user@1")
  end

  test "get_active_session/4 fetches session", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/access/users/user%401/active_sessions/nonce"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"nonce" => "nonce"}}}}
    end)

    assert {:ok, %{"nonce" => "nonce"}} =
             ZeroTrustUsers.get_active_session(client, "acc", "user@1", "nonce")
  end

  test "get_failed_logins/3 fetches logins", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/access/users/user%401/failed_logins"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} =
             ZeroTrustUsers.get_failed_logins(client, "acc", "user@1")
  end

  test "get_last_seen_identity/3 fetches identity", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/access/users/user%401/last_seen_identity"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"ip" => "1.2.3.4"}}}}
    end)

    assert {:ok, %{"ip" => "1.2.3.4"}} =
             ZeroTrustUsers.get_last_seen_identity(client, "acc", "user@1")
  end

  test "errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 8}]}}}
    end)

    assert {:error, [_]} = ZeroTrustUsers.list(client, "acc")
  end
end
