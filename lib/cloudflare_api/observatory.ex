defmodule CloudflareApi.Observatory do
  @moduledoc ~S"""
  Wraps Cloudflare Observatory (Speed API) endpoints under
  `/zones/:zone_id/speed_api`.
  """

  @doc ~S"""
  List availability statistics for monitored pages (`GET /speed_api/availabilities`).
  """
  def availabilities(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(zone_id) <> "/availabilities", opts))
    |> handle_response()
  end

  @doc ~S"""
  List tracked pages (`GET /speed_api/pages`).
  """
  def list_pages(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(zone_id) <> "/pages", opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a new test for a monitored page (`POST /speed_api/pages/:url/tests`).
  """
  def create_test(client, zone_id, page_url, params) when is_map(params) do
    c(client)
    |> Tesla.post(tests_path(zone_id, page_url), params)
    |> handle_response()
  end

  @doc ~S"""
  List historical tests for a page (`GET /speed_api/pages/:url/tests`).
  """
  def list_tests(client, zone_id, page_url, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(tests_path(zone_id, page_url), opts))
    |> handle_response()
  end

  @doc ~S"""
  Delete stored test results for a page (`DELETE /speed_api/pages/:url/tests`).
  """
  def delete_tests(client, zone_id, page_url) do
    c(client)
    |> Tesla.delete(tests_path(zone_id, page_url), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Fetch a single test (`GET /speed_api/pages/:url/tests/:test_id`).
  """
  def get_test(client, zone_id, page_url, test_id) do
    c(client)
    |> Tesla.get(test_path(zone_id, page_url, test_id))
    |> handle_response()
  end

  @doc ~S"""
  Retrieve performance trend data for a page (`GET /speed_api/pages/:url/trend`).
  """
  def page_trend(client, zone_id, page_url, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(page_path(zone_id, page_url) <> "/trend", opts))
    |> handle_response()
  end

  @doc ~S"""
  Get the scheduled test configuration for a page (`GET /speed_api/schedule/:url`).
  """
  def get_schedule(client, zone_id, page_url) do
    c(client)
    |> Tesla.get(schedule_path(zone_id, page_url))
    |> handle_response()
  end

  @doc ~S"""
  Create or update a scheduled test for a page (`POST /speed_api/schedule/:url`).
  """
  def create_schedule(client, zone_id, page_url, params) when is_map(params) do
    c(client)
    |> Tesla.post(schedule_path(zone_id, page_url), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a scheduled test (`DELETE /speed_api/schedule/:url`).
  """
  def delete_schedule(client, zone_id, page_url) do
    c(client)
    |> Tesla.delete(schedule_path(zone_id, page_url), body: %{})
    |> handle_response()
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/speed_api"
  defp page_path(zone_id, page_url), do: base_path(zone_id) <> "/pages/" <> encode(page_url)
  defp tests_path(zone_id, page_url), do: page_path(zone_id, page_url) <> "/tests"

  defp test_path(zone_id, page_url, test_id) do
    tests_path(zone_id, page_url) <> "/" <> encode(test_id)
  end

  defp schedule_path(zone_id, page_url),
    do: base_path(zone_id) <> "/schedule/" <> encode(page_url)

  defp with_query(path, []), do: path

  defp with_query(path, opts), do: path <> "?" <> CloudflareApi.uri_encode_opts(opts)

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

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
