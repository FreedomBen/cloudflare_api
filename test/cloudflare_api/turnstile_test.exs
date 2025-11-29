defmodule CloudflareApi.TurnstileTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Turnstile

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 fetches widgets", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/challenges/widgets?per_page=5"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"sitekey" => "key"}]}}}
    end)

    assert {:ok, [%{"sitekey" => "key"}]} =
             Turnstile.list(client, "acc", per_page: 5)
  end

  test "create/3 posts JSON", %{client: client} do
    params = %{"name" => "widget"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Turnstile.create(client, "acc", params)
  end

  test "rotate_secret/4 hits rotate endpoint", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url} = env ->
      assert String.ends_with?(url, "/rotate_secret")
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"success" => true}}}}
    end)

    assert {:ok, %{"success" => true}} =
             Turnstile.rotate_secret(client, "acc", "key")
  end

  test "delete/3 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 9000}]}}}
    end)

    assert {:error, [%{"code" => 9000}]} = Turnstile.delete(client, "acc", "missing")
  end
end
