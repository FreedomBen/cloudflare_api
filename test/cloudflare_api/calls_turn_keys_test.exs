defmodule CloudflareApi.CallsTurnKeysTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.CallsTurnKeys

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches turn keys", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/calls/turn_keys"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"id" => "key"}]}
       }}
    end)

    assert {:ok, [%{"id" => "key"}]} = CallsTurnKeys.list(client, "acc")
  end

  test "create/3 sends JSON body", %{client: client} do
    params = %{"name" => "key"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/calls/turn_keys"
      assert Jason.decode!(body) == params

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => params}
       }}
    end)

    assert {:ok, ^params} = CallsTurnKeys.create(client, "acc", params)
  end

  test "update/4 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{method: :put, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/calls/turn_keys/key"

      {:ok,
       %Tesla.Env{
         env
         | status: 400,
           body: %{"errors" => [%{"code" => 9000, "message" => "bad"}]}
       }}
    end)

    assert {:error, [%{"code" => 9000, "message" => "bad"}]} =
             CallsTurnKeys.update(client, "acc", "key", %{})
  end
end
