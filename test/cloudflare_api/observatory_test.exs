defmodule CloudflareApi.ObservatoryTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Observatory

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "availabilities/4 applies query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/speed_api/availabilities?region=us"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"status" => "up"}]}}}
    end)

    assert {:ok, [%{"status" => "up"}]} = Observatory.availabilities(client, "zone", region: "us")
  end

  test "create_test/4 encodes page URL in path", %{client: client} do
    params = %{"profile" => "desktop"}
    encoded_url = URI.encode_www_form("https://example.com/foo")

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/speed_api/pages/#{encoded_url}/tests"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "test"}}}}
    end)

    assert {:ok, %{"id" => "test"}} =
             Observatory.create_test(client, "zone", "https://example.com/foo", params)
  end

  test "delete_schedule/3 sends empty JSON body", %{client: client} do
    enc = URI.encode_www_form("https://example.com/foo")

    mock(fn %Tesla.Env{method: :delete, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/speed_api/schedule/#{enc}"
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} =
             Observatory.delete_schedule(client, "zone", "https://example.com/foo")
  end

  test "list_tests/4 surfaces API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 55}]}}}
    end)

    assert {:error, [%{"code" => 55}]} =
             Observatory.list_tests(client, "zone", "https://example.com")
  end
end
