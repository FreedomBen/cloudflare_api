defmodule CloudflareApi.SslTlsModeRecommendationTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.SslTlsModeRecommendation

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "recommendation/3 fetches recommendation", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/ssl/recommendation"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"value" => "strict"}}}}
    end)

    assert {:ok, %{"value" => "strict"}} =
             SslTlsModeRecommendation.recommendation(client, "zone")
  end

  test "recommendation/3 returns errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 502, body: %{"errors" => [%{"code" => 4}]}}}
    end)

    assert {:error, [%{"code" => 4}]} = SslTlsModeRecommendation.recommendation(client, "zone")
  end
end
