defmodule CloudflareApi.VectorizeTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Vectorize

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_indexes/3 encodes pagination", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/vectorize/v2/indexes?page=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"name" => "idx"}]}}}
    end)

    assert {:ok, [%{"name" => "idx"}]} =
             Vectorize.list_indexes(client, "acc", page: 2)
  end

  test "create_index/3 posts JSON", %{client: client} do
    params = %{"name" => "idx", "dimension" => 4}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Vectorize.create_index(client, "acc", params)
  end

  test "delete_index/3 hits delete endpoint", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url} = env ->
      assert String.ends_with?(url, "/idx")
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} = Vectorize.delete_index(client, "acc", "idx")
  end

  test "insert/query vectors", %{client: client} do
    insert = %{"id" => "vec1", "values" => [1.0, 2.0]}
    query = %{"top_k" => 3, "vector" => [1.0, 2.0]}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      cond do
        String.ends_with?(url, "/insert") ->
          assert Jason.decode!(body) == insert
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"count" => 1}}}}

        String.ends_with?(url, "/query") ->
          assert Jason.decode!(body) == query
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "vec1"}]}}}
      end
    end)

    assert {:ok, %{"count" => 1}} =
             Vectorize.insert_vectors(client, "acc", "idx", insert)

    assert {:ok, [%{"id" => "vec1"}]} =
             Vectorize.query(client, "acc", "idx", query)
  end

  test "metadata index helpers", %{client: client} do
    params = %{"name" => "field"}

    mock(fn
      %Tesla.Env{method: :post, url: url, body: body} = env ->
        assert String.contains?(url, "/metadata_index/create")
        assert Jason.decode!(body) == params
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}

      %Tesla.Env{method: :get, url: url} = env ->
        assert String.ends_with?(url, "/metadata_index/list")
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"name" => "field"}]}}}
    end)

    assert {:ok, ^params} =
             Vectorize.create_metadata_index(client, "acc", "idx", params)

    assert {:ok, [%{"name" => "field"}]} =
             Vectorize.list_metadata_indexes(client, "acc", "idx")
  end
end
