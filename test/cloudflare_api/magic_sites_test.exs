defmodule CloudflareApi.MagicSitesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.MagicSites

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      %URI{path: path, query: query} = URI.parse(url)
      assert path == "/client/v4/accounts/acc/magic/sites"
      assert URI.decode_query(query) == %{"page" => "2"}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = MagicSites.list(client, "acc", page: 2)
  end

  test "create/3 posts params", %{client: client} do
    params = %{"name" => "site"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = MagicSites.create(client, "acc", params)
  end

  test "delete/3 propagates errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 1200}]}}}
    end)

    assert {:error, [%{"code" => 1200}]} = MagicSites.delete(client, "acc", "missing")
  end
end
