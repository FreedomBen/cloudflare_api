defmodule CloudflareApi.WorkerDeployments do
  @moduledoc ~S"""
  Wraps Worker deployment endpoints (`/accounts/:account_id/workers/scripts/:script_name/deployments`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List deployments for a Worker (`GET /accounts/:account_id/workers/scripts/:script_name/deployments`).
  """
  def list(client, account_id, script_name) do
    c(client)
    |> Tesla.get(deployments_path(account_id, script_name))
    |> handle_response()
  end

  @doc ~S"""
  Create a deployment (`POST /accounts/:account_id/workers/scripts/:script_name/deployments`).

  Supports the optional `:force` query parameter.
  """
  def create(client, account_id, script_name, params, opts \\ []) when is_map(params) do
    c(client)
    |> Tesla.post(with_query(deployments_path(account_id, script_name), opts), params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch a deployment (`GET /accounts/:account_id/workers/scripts/:script_name/deployments/:deployment_id`).
  """
  def get(client, account_id, script_name, deployment_id) do
    c(client)
    |> Tesla.get(deployment_path(account_id, script_name, deployment_id))
    |> handle_response()
  end

  @doc ~S"""
  Delete a deployment (`DELETE /accounts/:account_id/workers/scripts/:script_name/deployments/:deployment_id`).
  """
  def delete(client, account_id, script_name, deployment_id) do
    c(client)
    |> Tesla.delete(deployment_path(account_id, script_name, deployment_id), body: %{})
    |> handle_response()
  end

  defp deployments_path(account_id, script_name),
    do: "/accounts/#{account_id}/workers/scripts/#{script_name}/deployments"

  defp deployment_path(account_id, script_name, deployment_id),
    do: deployments_path(account_id, script_name) <> "/#{deployment_id}"

  defp with_query(url, []), do: url

  defp with_query(url, opts), do: url <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
