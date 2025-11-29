defmodule CloudflareApi.ConnectivityServicesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ConnectivityServices

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes pagination opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/connectivity/directory/services?type=http&page=2&per_page=10"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"name" => "svc"}]}
       }}
    end)

    assert {:ok, [_]} =
             ConnectivityServices.list(client, "acc", type: "http", page: 2, per_page: 10)
  end

  test "create/3 posts JSON body", %{client: client} do
    params = %{"name" => "svc", "type" => "http"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = ConnectivityServices.create(client, "acc", params)
  end

  test "delete/3 propagates errors", %{client: client} do
    mock(fn %Tesla.Env{method: :delete} = env ->
      {:ok,
       %Tesla.Env{
         env
         | status: 404,
           body: %{"errors" => [%{"code" => 4040, "message" => "not found"}]}
       }}
    end)

    assert {:error, [%{"code" => 4040, "message" => "not found"}]} =
             ConnectivityServices.delete(client, "acc", "svc")
  end
end
