defmodule CloudflareApi.SecondaryDnsTsig do
  @moduledoc ~S"""
  Manage Secondary DNS TSIG keys under `/accounts/:account_id/secondary_dns/tsigs`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List TSIG keys for an account (`GET /secondary_dns/tsigs`).
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(account_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a TSIG key (`POST /secondary_dns/tsigs`).
  """
  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Retrieve a TSIG key (`GET /secondary_dns/tsigs/:tsig_id`).
  """
  def get(client, account_id, tsig_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(tsig_path(account_id, tsig_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Update a TSIG key (`PUT /secondary_dns/tsigs/:tsig_id`).
  """
  def update(client, account_id, tsig_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(tsig_path(account_id, tsig_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a TSIG key (`DELETE /secondary_dns/tsigs/:tsig_id`).
  """
  def delete(client, account_id, tsig_id) do
    c(client)
    |> Tesla.delete(tsig_path(account_id, tsig_id), body: %{})
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/secondary_dns/tsigs"

  defp tsig_path(account_id, tsig_id) do
    base_path(account_id) <> "/#{encode(tsig_id)}"
  end

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

  defp with_query(path, []), do: path
  defp with_query(path, opts), do: path <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
