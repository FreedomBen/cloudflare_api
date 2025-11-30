defmodule CloudflareApi.AiGatewayDynamicRoutes do
  @moduledoc ~S"""
  Manage AI Gateway dynamic routes, deployments, and versions.

  All functions directly wrap the `/accounts/:account_id/ai-gateway/gateways/:gateway_id`
  routes endpoints.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List dynamic routes for a gateway.
  """
  def list(client, account_id, gateway_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(account_id, gateway_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a new dynamic route.
  """
  def create(client, account_id, gateway_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id, gateway_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch a specific route.
  """
  def get(client, account_id, gateway_id, route_id) do
    c(client)
    |> Tesla.get(route_path(account_id, gateway_id, route_id))
    |> handle_response()
  end

  @doc ~S"""
  Update a route using `PATCH`.
  """
  def update(client, account_id, gateway_id, route_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(route_path(account_id, gateway_id, route_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a dynamic route.
  """
  def delete(client, account_id, gateway_id, route_id) do
    c(client)
    |> Tesla.delete(route_path(account_id, gateway_id, route_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  List deployments for a route.
  """
  def list_deployments(client, account_id, gateway_id, route_id, opts \\ []) do
    c(client)
    |> Tesla.get(deployment_url(account_id, gateway_id, route_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a deployment for a route.
  """
  def create_deployment(client, account_id, gateway_id, route_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(deployment_path(account_id, gateway_id, route_id), params)
    |> handle_response()
  end

  @doc ~S"""
  List versions of a route.
  """
  def list_versions(client, account_id, gateway_id, route_id, opts \\ []) do
    c(client)
    |> Tesla.get(version_url(account_id, gateway_id, route_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a new version for a route.
  """
  def create_version(client, account_id, gateway_id, route_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(version_path(account_id, gateway_id, route_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch details for a specific route version.
  """
  def get_version(client, account_id, gateway_id, route_id, version_id) do
    c(client)
    |> Tesla.get(version_item_path(account_id, gateway_id, route_id, version_id))
    |> handle_response()
  end

  defp list_url(account_id, gateway_id, []), do: base_path(account_id, gateway_id)

  defp list_url(account_id, gateway_id, opts) do
    base_path(account_id, gateway_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp deployment_url(account_id, gateway_id, route_id, []),
    do: deployment_path(account_id, gateway_id, route_id)

  defp deployment_url(account_id, gateway_id, route_id, opts) do
    deployment_path(account_id, gateway_id, route_id) <>
      "?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp version_url(account_id, gateway_id, route_id, []),
    do: version_path(account_id, gateway_id, route_id)

  defp version_url(account_id, gateway_id, route_id, opts) do
    version_path(account_id, gateway_id, route_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp base_path(account_id, gateway_id) do
    "/accounts/#{account_id}/ai-gateway/gateways/#{gateway_id}/routes"
  end

  defp route_path(account_id, gateway_id, route_id) do
    base_path(account_id, gateway_id) <> "/#{route_id}"
  end

  defp deployment_path(account_id, gateway_id, route_id) do
    route_path(account_id, gateway_id, route_id) <> "/deployments"
  end

  defp version_path(account_id, gateway_id, route_id) do
    route_path(account_id, gateway_id, route_id) <> "/versions"
  end

  defp version_item_path(account_id, gateway_id, route_id, version_id) do
    version_path(account_id, gateway_id, route_id) <> "/#{version_id}"
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
