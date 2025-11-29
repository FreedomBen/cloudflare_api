defmodule CloudflareApi.CustomOriginTrustStoreTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.CustomOriginTrustStore

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes pagination opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/acm/custom_trust_store?page=2&per_page=10"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"id" => "store"}]}
       }}
    end)

    assert {:ok, [_]} = CustomOriginTrustStore.list(client, "zone", page: 2, per_page: 10)
  end

  test "create/3 posts JSON payload", %{client: client} do
    params = %{"certificate" => "PEM"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = CustomOriginTrustStore.create(client, "zone", params)
  end

  test "delete/3 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{method: :delete} = env ->
      {:ok,
       %Tesla.Env{
         env
         | status: 404,
           body: %{"errors" => [%{"code" => 4040, "message" => "missing"}]}
       }}
    end)

    assert {:error, [%{"code" => 4040, "message" => "missing"}]} =
             CustomOriginTrustStore.delete(client, "zone", "store")
  end
end
