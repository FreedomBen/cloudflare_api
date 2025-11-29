defmodule CloudflareApi.PriorityIntelligenceRequirementsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.PriorityIntelligenceRequirements

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 posts filters", %{client: client} do
    params = %{"status" => "open"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/requests/priority"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "pir"}]}}}
    end)

    assert {:ok, [%{"id" => "pir"}]} =
             PriorityIntelligenceRequirements.list(client, "acc", params)
  end

  test "quota/2 fetches quota", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/requests/priority/quota"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"remaining" => 5}}}}
    end)

    assert {:ok, %{"remaining" => 5}} = PriorityIntelligenceRequirements.quota(client, "acc")
  end

  test "delete/3 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} =
             PriorityIntelligenceRequirements.delete(client, "acc", "pir")
  end

  test "get/3 returns errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 404}]}}}
    end)

    assert {:error, [%{"code" => 404}]} =
             PriorityIntelligenceRequirements.get(client, "acc", "missing")
  end
end
