defmodule CloudflareApi.MiscategorizationTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Miscategorization

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "create/3 posts request body", %{client: client} do
    params = %{"domain" => "example.com", "categories" => ["phishing"]}

    mock(fn %Tesla.Env{method: :post, body: body, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/intel/miscategorization"

      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"status" => "submitted"}}}}
    end)

    assert {:ok, %{"status" => "submitted"}} =
             Miscategorization.create(client, "acc", params)
  end

  test "create/3 propagates errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 44}]}}}
    end)

    assert {:error, [%{"code" => 44}]} =
             Miscategorization.create(client, "acc", %{})
  end
end
