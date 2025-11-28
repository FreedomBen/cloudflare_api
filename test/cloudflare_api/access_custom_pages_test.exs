defmodule CloudflareApi.AccessCustomPagesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccessCustomPages

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/access/custom_pages?page=2"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "page"}]}}}
    end)

    assert {:ok, [_]} = AccessCustomPages.list(client, "acc", page: 2)
  end

  test "create/4 sends JSON body", %{client: client} do
    params = %{"name" => "page"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = AccessCustomPages.create(client, "acc", params)
  end

  test "delete/3 normalises errors", %{client: client} do
    mock(fn %Tesla.Env{method: :delete} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 40}]}}}
    end)

    assert {:error, [%{"code" => 40}]} = AccessCustomPages.delete(client, "acc", "page")
  end
end
