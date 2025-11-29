defmodule CloudflareApi.PagesDeployments do
  @moduledoc ~S"""
  Manage Pages deployments (`/accounts/:account_id/pages/projects/:project_name/deployments`).
  """

  @doc ~S"""
  List deployments for a project (`GET /deployments`).
  """
  def list(client, account_id, project_name, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(account_id, project_name), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a deployment (`POST /deployments`).
  """
  def create(client, account_id, project_name, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id, project_name), params)
    |> handle_response()
  end

  @doc ~S"""
  Get deployment details (`GET /deployments/:deployment_id`).
  """
  def get(client, account_id, project_name, deployment_id) do
    c(client)
    |> Tesla.get(deployment_path(account_id, project_name, deployment_id))
    |> handle_response()
  end

  @doc ~S"""
  Delete a deployment (`DELETE /deployments/:deployment_id`).
  """
  def delete(client, account_id, project_name, deployment_id) do
    c(client)
    |> Tesla.delete(deployment_path(account_id, project_name, deployment_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Fetch deployment logs (`GET /deployments/:deployment_id/history/logs`).
  """
  def logs(client, account_id, project_name, deployment_id, opts \\ []) do
    c(client)
    |> Tesla.get(
      with_query(
        deployment_path(account_id, project_name, deployment_id) <> "/history/logs",
        opts
      )
    )
    |> handle_response()
  end

  @doc ~S"""
  Retry a deployment (`POST /deployments/:deployment_id/retry`).
  """
  def retry(client, account_id, project_name, deployment_id) do
    c(client)
    |> Tesla.post(deployment_path(account_id, project_name, deployment_id) <> "/retry", %{})
    |> handle_response()
  end

  @doc ~S"""
  Roll back to a deployment (`POST /deployments/:deployment_id/rollback`).
  """
  def rollback(client, account_id, project_name, deployment_id) do
    c(client)
    |> Tesla.post(deployment_path(account_id, project_name, deployment_id) <> "/rollback", %{})
    |> handle_response()
  end

  defp base_path(account_id, project_name) do
    "/accounts/#{account_id}/pages/projects/#{encode(project_name)}/deployments"
  end

  defp deployment_path(account_id, project_name, deployment_id) do
    base_path(account_id, project_name) <> "/#{encode(deployment_id)}"
  end

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
