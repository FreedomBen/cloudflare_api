defmodule CloudflareApi.DexSyntheticApplicationMonitoring do
  @moduledoc ~S"""
  Helper functions for the Digital Experience (DEX) Synthetic Application
  Monitoring endpoints under `/accounts/:account_id/dex`.

  Each function wraps a single `GET` endpoint and returns the decoded `result`
  payload from the Cloudflare JSON envelope (or an error tuple).
  """

  @doc ~S"""
  List Cloudflare colocation facilities aggregated by DEX
  (`GET /accounts/:account_id/dex/colos`).

    * `:from`, `:to` – ISO8601 time bounds
    * `:sortBy` – sort key
  """
  def list_colos(client, account_id, opts \\ []) do
    get(client, dex_path(account_id) <> "/colos" <> query_suffix(opts))
  end

  @doc ~S"""
  Fetch the latest live status for a specific device
  (`GET /accounts/:account_id/dex/devices/:device_id/fleet-status/live`).

  Accepts `:since_minutes`, `:time_now`, and `:colo` filters.
  """
  def device_live_status(client, account_id, device_id, opts \\ []) do
    get(
      client,
      dex_path(account_id) <> "/devices/#{device_id}/fleet-status/live" <> query_suffix(opts)
    )
  end

  @doc ~S"""
  List fleet-status devices (`GET /accounts/:account_id/dex/fleet-status/devices`).

  Supports pagination and filtering options (`:page`, `:per_page`, `:status`, etc.).
  """
  def fleet_status_devices(client, account_id, opts \\ []) do
    get(client, dex_path(account_id) <> "/fleet-status/devices" <> query_suffix(opts))
  end

  @doc ~S"""
  List fleet status details by dimension
  (`GET /accounts/:account_id/dex/fleet-status/live`).

  Optional `:since_minutes` filter.
  """
  def fleet_status_live(client, account_id, opts \\ []) do
    get(client, dex_path(account_id) <> "/fleet-status/live" <> query_suffix(opts))
  end

  @doc ~S"""
  Retrieve fleet status aggregates over time
  (`GET /accounts/:account_id/dex/fleet-status/over-time`).

  Accepts `:from`, `:to`, `:colo`, and `:device_id`.
  """
  def fleet_status_over_time(client, account_id, opts \\ []) do
    get(client, dex_path(account_id) <> "/fleet-status/over-time" <> query_suffix(opts))
  end

  @doc ~S"""
  Get HTTP test details and metrics
  (`GET /accounts/:account_id/dex/http-tests/:test_id`).

  Supports `:deviceId`, `:from`, `:to`, `:interval`, `:colo` filters.
  """
  def http_test_details(client, account_id, test_id, opts \\ []) do
    get(
      client,
      dex_path(account_id) <> "/http-tests/#{test_id}" <> query_suffix(opts)
    )
  end

  @doc ~S"""
  Get percentile metrics for an HTTP test
  (`GET /accounts/:account_id/dex/http-tests/:test_id/percentiles`).
  """
  def http_test_percentiles(client, account_id, test_id, opts \\ []) do
    get(
      client,
      dex_path(account_id) <> "/http-tests/#{test_id}/percentiles" <> query_suffix(opts)
    )
  end

  @doc ~S"""
  List DEX test analytics overview
  (`GET /accounts/:account_id/dex/tests/overview`).
  """
  def tests_overview(client, account_id, opts \\ []) do
    get(client, dex_path(account_id) <> "/tests/overview" <> query_suffix(opts))
  end

  @doc ~S"""
  Get the count of unique devices targeted by tests
  (`GET /accounts/:account_id/dex/tests/unique-devices`).
  """
  def tests_unique_devices(client, account_id, opts \\ []) do
    get(client, dex_path(account_id) <> "/tests/unique-devices" <> query_suffix(opts))
  end

  @doc ~S"""
  Retrieve the network path for a specific traceroute test run
  (`GET /accounts/:account_id/dex/traceroute-test-results/:test_result_id/network-path`).
  """
  def traceroute_test_result_network_path(client, account_id, test_result_id) do
    get(
      client,
      dex_path(account_id) <> "/traceroute-test-results/#{test_result_id}/network-path"
    )
  end

  @doc ~S"""
  Get traceroute test details and aggregates
  (`GET /accounts/:account_id/dex/traceroute-tests/:test_id`).
  """
  def traceroute_test_details(client, account_id, test_id, opts \\ []) do
    get(
      client,
      dex_path(account_id) <> "/traceroute-tests/#{test_id}" <> query_suffix(opts)
    )
  end

  @doc ~S"""
  Get traceroute network path breakdown
  (`GET /accounts/:account_id/dex/traceroute-tests/:test_id/network-path`).
  """
  def traceroute_test_network_path(client, account_id, test_id, opts \\ []) do
    get(
      client,
      dex_path(account_id) <> "/traceroute-tests/#{test_id}/network-path" <> query_suffix(opts)
    )
  end

  @doc ~S"""
  Fetch percentile metrics for a traceroute test
  (`GET /accounts/:account_id/dex/traceroute-tests/:test_id/percentiles`).
  """
  def traceroute_test_percentiles(client, account_id, test_id, opts \\ []) do
    get(
      client,
      dex_path(account_id) <> "/traceroute-tests/#{test_id}/percentiles" <> query_suffix(opts)
    )
  end

  defp dex_path(account_id), do: "/accounts/#{account_id}/dex"

  defp query_suffix([]), do: ""
  defp query_suffix(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

  defp get(client, path) do
    c(client)
    |> Tesla.get(path)
    |> handle_response()
  end

  defp handle_response({:ok, %Tesla.Env{status: status, body: %{"result" => result}}})
       when status in 200..299,
       do: {:ok, result}

  defp handle_response({:ok, %Tesla.Env{status: status, body: body}}) when status in 200..299,
    do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{body: %{"errors" => errors}}}), do: {:error, errors}
  defp handle_response(other), do: {:error, other}

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
