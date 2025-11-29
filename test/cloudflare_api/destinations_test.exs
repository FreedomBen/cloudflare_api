defmodule CloudflareApi.DestinationsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Destinations

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches destinations", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/workers/observability/destinations"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"slug" => "s"}]}}}
    end)

    assert {:ok, [_]} = Destinations.list(client, "acc")
  end

  test "create/3 posts JSON", %{client: client} do
    params = %{"slug" => "dest"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Destinations.create(client, "acc", params)
  end

  test "update/4 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"message" => "bad"}]}}}
    end)

    assert {:error, [%{"message" => "bad"}]} =
             Destinations.update(client, "acc", "slug", %{"name" => "new"})
  end

  test "delete/3 sends empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} = Destinations.delete(client, "acc", "slug")
  end
end
