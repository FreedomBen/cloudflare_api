defmodule CloudflareApi.AutoragRagsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AutoragRags

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/autorag/rags?per_page=10"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "rag"}]}}}
    end)

    assert {:ok, [_]} = AutoragRags.list(client, "acc", per_page: 10)
  end

  test "create/3 sends JSON body", %{client: client} do
    params = %{"name" => "docs"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/autorag/rags"
      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = AutoragRags.create(client, "acc", params)
  end

  test "delete/3 returns API errors", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/autorag/rags/rag"

      {:ok,
       %Tesla.Env{
         env
         | status: 404,
           body: %{"errors" => [%{"code" => 4004, "message" => "missing rag"}]}
       }}
    end)

    assert {:error, [%{"code" => 4004, "message" => "missing rag"}]} =
             AutoragRags.delete(client, "acc", "rag")
  end
end
