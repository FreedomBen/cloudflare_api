defmodule CloudflareApi.NamespaceManagementTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.NamespaceManagement

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/4 fetches namespaces", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      %URI{path: path, query: query} = URI.parse(url)

      assert path ==
               "/client/v4/accounts/acc/r2-catalog/bucket/namespaces"

      assert URI.decode_query(query) == %{"cursor" => "abc"}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} =
             NamespaceManagement.list(client, "acc", "bucket", cursor: "abc")
  end

  test "list/4 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 1}]}}}
    end)

    assert {:error, [%{"code" => 1}]} =
             NamespaceManagement.list(client, "acc", "bucket")
  end
end
