defmodule CloudflareApi.WorkerRoutes do
  @moduledoc ~S"""
  Manage Cloudflare Worker routes for a zone.

  These helpers wrap the `/zones/:zone_id/workers/routes` endpoints, keeping
  the API close to the HTTP interface while normalising responses into
  `{:ok, result}` / `{:error, errors}` tuples.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List worker routes for the given zone (`GET /zones/:zone_id/workers/routes`).
  """
  def list(client, zone_id) do
    case Tesla.get(c(client), "/zones/#{zone_id}/workers/routes") do
      {:ok, %Tesla.Env{status: 200, body: body}} -> {:ok, body["result"]}
      {:ok, %Tesla.Env{body: %{"errors" => errs}}} -> {:error, errs}
      err -> {:error, err}
    end
  end

  @doc ~S"""
  Create a worker route (`POST /zones/:zone_id/workers/routes`).

  The `params` map should include the fields Cloudflare expects, primarily
  `pattern` and `script`.
  """
  def create(client, zone_id, params) when is_map(params) do
    case Tesla.post(c(client), "/zones/#{zone_id}/workers/routes", params) do
      {:ok, %Tesla.Env{status: 200, body: body}} -> {:ok, body["result"]}
      {:ok, %Tesla.Env{body: %{"errors" => errs}}} -> {:error, errs}
      err -> {:error, err}
    end
  end

  @doc ~S"""
  Retrieve a single worker route (`GET /zones/:zone_id/workers/routes/:route_id`).
  """
  def get(client, zone_id, route_id) do
    case Tesla.get(c(client), route_path(zone_id, route_id)) do
      {:ok, %Tesla.Env{status: 200, body: body}} -> {:ok, body["result"]}
      {:ok, %Tesla.Env{body: %{"errors" => errs}}} -> {:error, errs}
      err -> {:error, err}
    end
  end

  @doc ~S"""
  Update a worker route (`PUT /zones/:zone_id/workers/routes/:route_id`).
  """
  def update(client, zone_id, route_id, params) when is_map(params) do
    case Tesla.put(c(client), route_path(zone_id, route_id), params) do
      {:ok, %Tesla.Env{status: 200, body: body}} -> {:ok, body["result"]}
      {:ok, %Tesla.Env{body: %{"errors" => errs}}} -> {:error, errs}
      err -> {:error, err}
    end
  end

  @doc ~S"""
  Delete a worker route (`DELETE /zones/:zone_id/workers/routes/:route_id`).
  """
  def delete(client, zone_id, route_id) do
    case Tesla.delete(c(client), route_path(zone_id, route_id), body: %{}) do
      {:ok, %Tesla.Env{status: 200, body: body}} -> {:ok, body["result"]}
      {:ok, %Tesla.Env{body: %{"errors" => errs}}} -> {:error, errs}
      err -> {:error, err}
    end
  end

  defp route_path(zone_id, route_id), do: "/zones/#{zone_id}/workers/routes/#{route_id}"

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
