defmodule CloudflareApi.WorkerDomain do
  @moduledoc ~S"""
  Manage Workers custom domains (`/accounts/:account_id/workers/domains`).

  Supports listing/filtering domains, attaching a Worker to a domain, fetching
  individual domain records, and detaching domains.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List domains for an account (`GET /accounts/:account_id/workers/domains`).

  Accepts the filter options supported by the API (e.g. `:zone_name`,
  `:service`, `:zone_id`, `:hostname`, `:environment`).
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(account_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Attach a Worker to a domain (`PUT /accounts/:account_id/workers/domains`).
  """
  def attach(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch an attached domain (`GET /accounts/:account_id/workers/domains/:domain_id`).
  """
  def get(client, account_id, domain_id) do
    c(client)
    |> Tesla.get(domain_path(account_id, domain_id))
    |> handle_response()
  end

  @doc ~S"""
  Detach a domain (`DELETE /accounts/:account_id/workers/domains/:domain_id`).
  """
  def detach(client, account_id, domain_id) do
    c(client)
    |> Tesla.delete(domain_path(account_id, domain_id), body: %{})
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/workers/domains"

  defp domain_path(account_id, domain_id),
    do: base_path(account_id) <> "/#{encode(domain_id)}"

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

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
