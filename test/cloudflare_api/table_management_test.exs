defmodule CloudflareApi.TableManagementTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.TableManagement

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/5 encodes params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/r2-catalog/bkt/namespaces/ns/tables?page=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"name" => "tbl"}]}}}
    end)

    assert {:ok, [%{"name" => "tbl"}]} =
             TableManagement.list(client, "acc", "bkt", "ns", page: 2)
  end

  test "list/5 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 12}]}}}
    end)

    assert {:error, [%{"code" => 12}]} =
             TableManagement.list(client, "acc", "bkt", "ns")
  end
end
