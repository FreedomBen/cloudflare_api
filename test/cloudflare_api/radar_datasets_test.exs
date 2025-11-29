defmodule CloudflareApi.RadarDatasetsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarDatasets

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches datasets", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/datasets"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"alias" => "http"}]}}}
    end)

    assert {:ok, [%{"alias" => "http"}]} = RadarDatasets.list(client)
  end

  test "get/3 encodes alias", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/datasets/http"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"alias" => "http"}}}}
    end)

    assert {:ok, %{"alias" => "http"}} = RadarDatasets.get(client, "http")
  end

  test "request_download_url/2 posts params", %{client: client} do
    params = %{"alias" => "http", "format" => "csv"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/datasets/download"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"url" => "https://"}}}}
    end)

    assert {:ok, %{"url" => "https://"}} = RadarDatasets.request_download_url(client, params)
  end

  test "get/3 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 5}]}}}
    end)

    assert {:error, [%{"code" => 5}]} = RadarDatasets.get(client, "missing")
  end
end
