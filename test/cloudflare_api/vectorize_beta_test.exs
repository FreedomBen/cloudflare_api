defmodule CloudflareApi.VectorizeBetaTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.VectorizeBeta

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_indexes/3 hits deprecated path", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/vectorize/indexes"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = VectorizeBeta.list_indexes(client, "acc")
  end

  test "update_index/4 uses PUT", %{client: client} do
    params = %{"description" => "updated"}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             VectorizeBeta.update_index(client, "acc", "idx", params)
  end

  test "delete_vectors_by_ids/4 posts payload", %{client: client} do
    params = %{"ids" => ["1"]}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert String.ends_with?(url, "/delete-by-ids")
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => 1}}}}
    end)

    assert {:ok, %{"deleted" => 1}} =
             VectorizeBeta.delete_vectors_by_ids(client, "acc", "idx", params)
  end
end
