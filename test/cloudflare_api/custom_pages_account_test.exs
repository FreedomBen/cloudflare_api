defmodule CloudflareApi.CustomPagesAccountTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.CustomPagesAccount

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches account pages", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/custom_pages"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"id" => "waf_challenge"}]}
       }}
    end)

    assert {:ok, [_]} = CustomPagesAccount.list(client, "acc")
  end

  test "update/4 sends JSON payload", %{client: client} do
    params = %{"state" => "default", "url" => "https://example.com/challenge.html"}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             CustomPagesAccount.update(client, "acc", "waf_challenge", params)
  end
end
