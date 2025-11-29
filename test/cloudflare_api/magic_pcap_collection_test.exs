defmodule CloudflareApi.MagicPcapCollectionTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.MagicPcapCollection

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_requests/2 fetches pcap requests", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/pcaps"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = MagicPcapCollection.list_requests(client, "acc")
  end

  test "create_request/3 posts params", %{client: client} do
    params = %{"name" => "pcap"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/pcaps"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = MagicPcapCollection.create_request(client, "acc", params)
  end

  test "download_request/3 hits download path", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/pcaps/pcap1/download"

      {:ok, %Tesla.Env{env | status: 200, body: "pcap-bytes"}}
    end)

    assert {:ok, "pcap-bytes"} = MagicPcapCollection.download_request(client, "acc", "pcap1")
  end

  test "stop_request/3 returns :no_content", %{client: client} do
    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/pcaps/pcap1/stop"

      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 204, body: ""}}
    end)

    assert {:ok, :no_content} = MagicPcapCollection.stop_request(client, "acc", "pcap1")
  end

  test "list_ownership/2 fetches ownership buckets", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/pcaps/ownership"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = MagicPcapCollection.list_ownership(client, "acc")
  end

  test "delete_ownership/3 propagates Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 2001}]}}}
    end)

    assert {:error, [%{"code" => 2001}]} =
             MagicPcapCollection.delete_ownership(client, "acc", "ownership")
  end
end
