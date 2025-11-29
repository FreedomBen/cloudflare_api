defmodule CloudflareApi.DexSyntheticApplicationMonitoringTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.DexSyntheticApplicationMonitoring

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_colos/3 applies time filters", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dex/colos?from=2024-01-01T00%3A00%3A00Z&to=2024-01-02T00%3A00%3A00Z"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"colo" => "SFO"}]}}}
    end)

    assert {:ok, [_]} =
             DexSyntheticApplicationMonitoring.list_colos(client, "acc",
               from: "2024-01-01T00:00:00Z",
               to: "2024-01-02T00:00:00Z"
             )
  end

  test "device_live_status/4 includes device id and opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dex/devices/dev123/fleet-status/live?since_minutes=15"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"status" => "ok"}}}}
    end)

    assert {:ok, %{"status" => "ok"}} =
             DexSyntheticApplicationMonitoring.device_live_status(
               client,
               "acc",
               "dev123",
               since_minutes: 15
             )
  end

  test "fleet_status_devices/3 forwards pagination opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dex/fleet-status/devices?page=2&per_page=5&status=offline"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"device_id" => "dev"}]}}}
    end)

    assert {:ok, [_]} =
             DexSyntheticApplicationMonitoring.fleet_status_devices(client, "acc",
               page: 2,
               per_page: 5,
               status: "offline"
             )
  end

  test "http_test_details/4 builds the right path", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dex/http-tests/test123?deviceId=dev&interval=5m"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "test123"}}}}
    end)

    assert {:ok, %{"id" => "test123"}} =
             DexSyntheticApplicationMonitoring.http_test_details(
               client,
               "acc",
               "test123",
               deviceId: "dev",
               interval: "5m"
             )
  end

  test "tests_overview/3 supports filters", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dex/tests/overview?colo=SFO&page=1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"name" => "Login"}]}}}
    end)

    assert {:ok, [_]} =
             DexSyntheticApplicationMonitoring.tests_overview(client, "acc",
               colo: "SFO",
               page: 1
             )
  end

  test "traceroute_test_result_network_path/3 hits result endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dex/traceroute-test-results/run123/network-path"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"hops" => []}}}}
    end)

    assert {:ok, %{"hops" => []}} =
             DexSyntheticApplicationMonitoring.traceroute_test_result_network_path(
               client,
               "acc",
               "run123"
             )
  end

  test "traceroute_test_percentiles/4 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 422, body: %{"errors" => [%{"message" => "bad interval"}]}}}
    end)

    assert {:error, [%{"message" => "bad interval"}]} =
             DexSyntheticApplicationMonitoring.traceroute_test_percentiles(
               client,
               "acc",
               "test123",
               interval: "bad"
             )
  end
end
