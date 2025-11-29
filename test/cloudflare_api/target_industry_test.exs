defmodule CloudflareApi.TargetIndustryTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.TargetIndustry

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 hits base endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/targetIndustries?per_page=5"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"name" => "Finance"}]}}}
    end)

    assert {:ok, [%{"name" => "Finance"}]} =
             TargetIndustry.list(client, "acc", per_page: 5)
  end

  test "list_catalog/3 hits catalog path", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url =~ "/targetIndustries/catalog"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"name" => "Full"}]}}}
    end)

    assert {:ok, [%{"name" => "Full"}]} = TargetIndustry.list_catalog(client, "acc")
  end

  test "list_for_dataset/4 encodes dataset id", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/dataset/data-id/targetIndustries"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "ti"}]}}}
    end)

    assert {:ok, [%{"id" => "ti"}]} =
             TargetIndustry.list_for_dataset(client, "acc", "data-id")
  end
end
