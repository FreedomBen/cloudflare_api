defmodule CloudflareApi.BuildTokensTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.BuildTokens

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes pagination opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/builds/tokens?page=2&per_page=5"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"build_token_uuid" => "uuid"}]}
       }}
    end)

    assert {:ok, [%{"build_token_uuid" => "uuid"}]} =
             BuildTokens.list(client, "acc", page: 2, per_page: 5)
  end

  test "create/3 sends JSON payload", %{client: client} do
    params = %{
      "build_token_name" => "token",
      "build_token_secret" => "secret",
      "cloudflare_token_id" => "cf"
    }

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/builds/tokens"
      assert Jason.decode!(body) == params

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => params}
       }}
    end)

    assert {:ok, ^params} = BuildTokens.create(client, "acc", params)
  end

  test "delete/3 bubbles up API errors", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/builds/tokens/uuid"

      {:ok,
       %Tesla.Env{
         env
         | status: 403,
           body: %{"errors" => [%{"code" => 4030, "message" => "forbidden"}]}
       }}
    end)

    assert {:error, [%{"code" => 4030, "message" => "forbidden"}]} =
             BuildTokens.delete(client, "acc", "uuid")
  end
end
