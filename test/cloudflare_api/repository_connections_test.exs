defmodule CloudflareApi.RepositoryConnectionsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RepositoryConnections

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "upsert/3 puts JSON body", %{client: client} do
    params = %{"repo_url" => "https://github.com"}

    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/builds/repos/connections"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = RepositoryConnections.upsert(client, "acc", params)
  end

  test "delete/3 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} =
             RepositoryConnections.delete(client, "acc", "uuid")
  end

  test "delete/3 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 77}]}}}
    end)

    assert {:error, [%{"code" => 77}]} = RepositoryConnections.delete(client, "acc", "missing")
  end
end
