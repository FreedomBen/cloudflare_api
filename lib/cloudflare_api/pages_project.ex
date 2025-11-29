defmodule CloudflareApi.PagesProject do
  @moduledoc ~S"""
  Manage Pages projects under `/accounts/:account_id/pages/projects`.
  """

  @doc ~S"""
  List projects in an account (`GET /accounts/:account_id/pages/projects`).
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(account_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a Pages project (`POST /accounts/:account_id/pages/projects`).
  """
  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch a specific project (`GET /accounts/:account_id/pages/projects/:project_name`).
  """
  def get(client, account_id, project_name, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(project_path(account_id, project_name), opts))
    |> handle_response()
  end

  @doc ~S"""
  Update a project (`PATCH /accounts/:account_id/pages/projects/:project_name`).
  """
  def update(client, account_id, project_name, params) when is_map(params) do
    c(client)
    |> Tesla.patch(project_path(account_id, project_name), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a project (`DELETE /accounts/:account_id/pages/projects/:project_name`).
  """
  def delete(client, account_id, project_name) do
    c(client)
    |> Tesla.delete(project_path(account_id, project_name), body: %{})
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/pages/projects"

  defp project_path(account_id, project_name) do
    base_path(account_id) <> "/#{encode(project_name)}"
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
