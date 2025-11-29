defmodule CloudflareApi.ResourcesCatalog do
  @moduledoc ~S"""
  Manage Magic Cloud resource catalog entries (`/accounts/:account_id/magic/cloud/resources`).
  """

  def list(client, account_id, opts \\ []) do
    fetch(client, base_path(account_id), opts)
  end

  def export(client, account_id, opts \\ []) do
    fetch(client, base_path(account_id) <> "/export", opts)
  end

  def policy_preview(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id) <> "/policy-preview", params)
    |> handle_response()
  end

  def get(client, account_id, resource_id, opts \\ []) do
    fetch(client, base_path(account_id) <> "/#{encode(resource_id)}", opts)
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/magic/cloud/resources"

  defp fetch(client_or_fun, path, opts) do
    c(client_or_fun)
    |> Tesla.get(with_query(path, opts))
    |> handle_response()
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
