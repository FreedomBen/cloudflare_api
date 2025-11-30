defmodule CloudflareApi.HealthChecks do
  @moduledoc ~S"""
  Manage Health Checks and Smart Shield Health Checks.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List health checks for a zone (`GET /zones/:zone_id/healthchecks`).
  """
  def list(client, zone_id, opts \\ []) do
    request(client, :get, base_path(zone_id) <> query_suffix(opts))
  end

  @doc ~S"""
  Create a health check (`POST /zones/:zone_id/healthchecks`).
  """
  def create(client, zone_id, params) when is_map(params) do
    request(client, :post, base_path(zone_id), params)
  end

  @doc ~S"""
  Retrieve a health check (`GET /zones/:zone_id/healthchecks/:healthcheck_id`).
  """
  def get(client, zone_id, healthcheck_id) do
    request(client, :get, healthcheck_path(zone_id, healthcheck_id))
  end

  @doc ~S"""
  Delete a health check (`DELETE /zones/:zone_id/healthchecks/:healthcheck_id`).
  """
  def delete(client, zone_id, healthcheck_id) do
    request(client, :delete, healthcheck_path(zone_id, healthcheck_id), %{})
  end

  @doc ~S"""
  Update a health check (`PUT /zones/:zone_id/healthchecks/:healthcheck_id`).
  """
  def update(client, zone_id, healthcheck_id, params) when is_map(params) do
    request(client, :put, healthcheck_path(zone_id, healthcheck_id), params)
  end

  @doc ~S"""
  Patch a health check (`PATCH /zones/:zone_id/healthchecks/:healthcheck_id`).
  """
  def patch(client, zone_id, healthcheck_id, params) when is_map(params) do
    request(client, :patch, healthcheck_path(zone_id, healthcheck_id), params)
  end

  @doc ~S"""
  Create a preview health check (`POST /zones/:zone_id/healthchecks/preview`).
  """
  def create_preview(client, zone_id, params) when is_map(params) do
    request(client, :post, preview_path(zone_id), params)
  end

  @doc ~S"""
  Get a preview health check (`GET /zones/:zone_id/healthchecks/preview/:id`).
  """
  def get_preview(client, zone_id, preview_id) do
    request(client, :get, preview_item_path(zone_id, preview_id))
  end

  @doc ~S"""
  Delete a preview health check (`DELETE /zones/:zone_id/healthchecks/preview/:id`).
  """
  def delete_preview(client, zone_id, preview_id) do
    request(client, :delete, preview_item_path(zone_id, preview_id), %{})
  end

  @doc ~S"""
  List Smart Shield health checks (`GET /zones/:zone_id/smart_shield/healthchecks`).
  """
  def smart_list(client, zone_id, opts \\ []) do
    request(client, :get, smart_path(zone_id) <> query_suffix(opts))
  end

  @doc ~S"""
  Create a Smart Shield health check (`POST /zones/:zone_id/smart_shield/healthchecks`).
  """
  def smart_create(client, zone_id, params) when is_map(params) do
    request(client, :post, smart_path(zone_id), params)
  end

  @doc ~S"""
  Retrieve a Smart Shield health check (`GET /zones/:zone_id/smart_shield/healthchecks/:id`).
  """
  def smart_get(client, zone_id, healthcheck_id) do
    request(client, :get, smart_item_path(zone_id, healthcheck_id))
  end

  @doc ~S"""
  Delete a Smart Shield health check (`DELETE /zones/:zone_id/smart_shield/healthchecks/:id`).
  """
  def smart_delete(client, zone_id, healthcheck_id) do
    request(client, :delete, smart_item_path(zone_id, healthcheck_id), %{})
  end

  @doc ~S"""
  Update a Smart Shield health check (`PUT /zones/:zone_id/smart_shield/healthchecks/:id`).
  """
  def smart_update(client, zone_id, healthcheck_id, params) when is_map(params) do
    request(client, :put, smart_item_path(zone_id, healthcheck_id), params)
  end

  @doc ~S"""
  Patch a Smart Shield health check (`PATCH /zones/:zone_id/smart_shield/healthchecks/:id`).
  """
  def smart_patch(client, zone_id, healthcheck_id, params) when is_map(params) do
    request(client, :patch, smart_item_path(zone_id, healthcheck_id), params)
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/healthchecks"
  defp healthcheck_path(zone_id, id), do: base_path(zone_id) <> "/#{id}"
  defp preview_path(zone_id), do: base_path(zone_id) <> "/preview"
  defp preview_item_path(zone_id, id), do: preview_path(zone_id) <> "/#{id}"
  defp smart_path(zone_id), do: "/zones/#{zone_id}/smart_shield/healthchecks"
  defp smart_item_path(zone_id, id), do: smart_path(zone_id) <> "/#{id}"

  defp query_suffix([]), do: ""
  defp query_suffix(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} ->
          Tesla.get(client, url)

        {:post, %{} = params} ->
          Tesla.post(client, url, params)

        {:put, %{} = params} ->
          Tesla.put(client, url, params)

        {:patch, %{} = params} ->
          Tesla.patch(client, url, params)

        {:delete, %{} = params} ->
          Tesla.delete(client, url, body: params)

        {:delete, nil} ->
          Tesla.delete(client, url)
      end

    handle_response(result)
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
