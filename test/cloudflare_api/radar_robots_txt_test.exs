defmodule CloudflareApi.RadarRobotsTxtTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarRobotsTxt

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "top_domain_categories/2 fetches categories", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/robots_txt/top/domain_categories"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"category" => "news"}]}}}
    end)

    assert {:ok, [%{"category" => "news"}]} = RadarRobotsTxt.top_domain_categories(client)
  end

  test "top_user_agents_by_directive/2 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 403, body: %{"errors" => [%{"code" => 5}]}}}
    end)

    assert {:error, [%{"code" => 5}]} = RadarRobotsTxt.top_user_agents_by_directive(client)
  end
end
