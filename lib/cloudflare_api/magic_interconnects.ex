defmodule CloudflareApi.MagicInterconnects do
  @moduledoc ~S"""
  Manage Magic WAN interconnects via `/accounts/:account_id/magic/cf_interconnects`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List Magic Interconnects for an account (`GET /accounts/:account_id/magic/cf_interconnects`).
  Optional `opts` are encoded onto the query string (pagination, filters, etc.).
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(account_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Update multiple interconnect definitions in bulk.

  Wraps `PUT /accounts/:account_id/magic/cf_interconnects` and sends `params`
  as the JSON body.
  """
  def update_many(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Retrieve details for a single interconnect (`GET /accounts/:account_id/magic/cf_interconnects/:id`).
  """
  def get(client, account_id, interconnect_id) do
    c(client)
    |> Tesla.get(interconnect_path(account_id, interconnect_id))
    |> handle_response()
  end

  @doc ~S"""
  Update a specific interconnect (`PUT /accounts/:account_id/magic/cf_interconnects/:id`).
  """
  def update(client, account_id, interconnect_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(interconnect_path(account_id, interconnect_id), params)
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/magic/cf_interconnects"

  defp interconnect_path(account_id, interconnect_id),
    do: base_path(account_id) <> "/#{interconnect_id}"

  defp list_url(account_id, []), do: base_path(account_id)

  defp list_url(account_id, opts),
    do: base_path(account_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
