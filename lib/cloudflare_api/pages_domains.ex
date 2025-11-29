defmodule CloudflareApi.PagesDomains do
  @moduledoc ~S"""
  Manage Pages project domains under `/accounts/:account_id/pages/projects/:project_name/domains`.
  """

  @doc ~S"""
  List all custom domains for a Pages project (`GET /domains`).
  """
  def list(client, account_id, project_name, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(account_id, project_name), opts))
    |> handle_response()
  end

  @doc ~S"""
  Add a domain to a Pages project (`POST /domains`).
  """
  def create(client, account_id, project_name, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id, project_name), params)
    |> handle_response()
  end

  @doc ~S"""
  Retrieve details for a single domain (`GET /domains/:domain_name`).
  """
  def get(client, account_id, project_name, domain_name, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(domain_path(account_id, project_name, domain_name), opts))
    |> handle_response()
  end

  @doc ~S"""
  Re-run validation for a domain (`PATCH /domains/:domain_name`).
  """
  def update(client, account_id, project_name, domain_name) do
    c(client)
    |> Tesla.patch(domain_path(account_id, project_name, domain_name), %{})
    |> handle_response()
  end

  @doc ~S"""
  Delete a domain (`DELETE /domains/:domain_name`).
  """
  def delete(client, account_id, project_name, domain_name) do
    c(client)
    |> Tesla.delete(domain_path(account_id, project_name, domain_name), body: %{})
    |> handle_response()
  end

  defp base_path(account_id, project_name) do
    "/accounts/#{account_id}/pages/projects/#{encode(project_name)}/domains"
  end

  defp domain_path(account_id, project_name, domain_name) do
    base_path(account_id, project_name) <> "/#{encode(domain_name)}"
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
