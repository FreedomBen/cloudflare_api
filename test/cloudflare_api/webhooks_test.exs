defmodule CloudflareApi.WebhooksTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Webhooks

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  @cases [
    %{
      fun: :list,
      args: ["acc", "app"],
      method: :get,
      path: "/accounts/acc/realtime/kit/app/webhooks"
    },
    %{
      fun: :create,
      args: ["acc", "app", %{"url" => "https://example.com"}],
      method: :post,
      path: "/accounts/acc/realtime/kit/app/webhooks",
      body: %{"url" => "https://example.com"}
    },
    %{
      fun: :get,
      args: ["acc", "app", "wh"],
      method: :get,
      path: "/accounts/acc/realtime/kit/app/webhooks/wh"
    },
    %{
      fun: :patch,
      args: ["acc", "app", "wh", %{"description" => "demo"}],
      method: :patch,
      path: "/accounts/acc/realtime/kit/app/webhooks/wh",
      body: %{"description" => "demo"}
    },
    %{
      fun: :replace,
      args: ["acc", "app", "wh", %{"url" => "https://new"}],
      method: :put,
      path: "/accounts/acc/realtime/kit/app/webhooks/wh",
      body: %{"url" => "https://new"}
    },
    %{
      fun: :delete,
      args: ["acc", "app", "wh"],
      method: :delete,
      path: "/accounts/acc/realtime/kit/app/webhooks/wh"
    }
  ]

  for %{fun: fun, args: args, method: method, path: path} = entry <- @cases do
    body = Map.get(entry, :body, :no_body)

    test "#{fun} targets #{path}", %{client: client} do
      mock(fn %Tesla.Env{method: unquote(method), url: url} = env ->
        assert url == @base <> unquote(path)

        case unquote(Macro.escape(body)) do
          :no_body -> :ok
          expected -> assert Jason.decode!(env.body) == expected
        end

        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"ok" => true}}}}
      end)

      assert {:ok, %{"ok" => true}} =
               apply(Webhooks, unquote(fun), [client | unquote(Macro.escape(args))])
    end
  end

  test "propagates webhook errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 403, body: %{"errors" => [%{"code" => 1234}]}}}
    end)

    assert {:error, [%{"code" => 1234}]} =
             Webhooks.create(client, "acc", "app", %{"url" => "bad"})
  end
end
