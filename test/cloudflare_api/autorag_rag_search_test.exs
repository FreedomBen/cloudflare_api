defmodule CloudflareApi.AutoragRagSearchTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AutoragRagSearch

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "search/4 posts params to the search endpoint", %{client: client} do
    params = %{"query" => "hello"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/autorag/rags/rag/search"

      assert Jason.decode!(body) == params

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"text" => "world"}]}
       }}
    end)

    assert {:ok, [%{"text" => "world"}]} =
             AutoragRagSearch.search(client, "acc", "rag", params)
  end

  test "search/4 returns Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok,
       %Tesla.Env{
         env
         | status: 422,
           body: %{"errors" => [%{"code" => 5555, "message" => "bad query"}]}
       }}
    end)

    assert {:error, [%{"code" => 5555, "message" => "bad query"}]} =
             AutoragRagSearch.search(client, "acc", "rag", %{})
  end
end
