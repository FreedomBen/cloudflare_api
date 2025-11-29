defmodule CloudflareApi.MagicStaticRoutesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.MagicStaticRoutes

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 includes validate_only query", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      %URI{path: path, query: query} = URI.parse(url)
      assert path == "/client/v4/accounts/acc/magic/routes"
      assert URI.decode_query(query) == %{"validate_only" => "true"}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = MagicStaticRoutes.list(client, "acc", validate_only: true)
  end

  test "create/4 posts params with opts", %{client: client} do
    params = %{"prefix" => "192.0.2.0/24"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/magic/routes?validate_only=true"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             MagicStaticRoutes.create(client, "acc", params, validate_only: true)
  end

  test "delete_many/4 sends JSON body", %{client: client} do
    params = %{"ids" => ["1", "2"]}

    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => 2}}}}
    end)

    assert {:ok, %{"deleted" => 2}} =
             MagicStaticRoutes.delete_many(client, "acc", params)
  end

  test "update/4 propagates errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 999}]}}}
    end)

    assert {:error, [%{"code" => 999}]} =
             MagicStaticRoutes.update(client, "acc", "route", %{"prefix" => "10.0.0.0/24"})
  end
end
