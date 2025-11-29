defmodule CloudflareApi.ZeroTrustGatewayLocations do
  @moduledoc ~S"""
  Manage Zero Trust Gateway locations (`/accounts/:account_id/gateway/locations`).
  """

  @doc """
  List locations (`GET /accounts/:account_id/gateway/locations`).

  Supports filters like `:page` and `:per_page`.
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(account_id), opts))
    |> handle_response()
  end

  @doc """
  Create a location (`POST /accounts/:account_id/gateway/locations`).
  """
  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc """
  Delete a location (`DELETE .../locations/:location_id`).
  """
  def delete(client, account_id, location_id) do
    c(client)
    |> Tesla.delete(location_path(account_id, location_id), body: %{})
    |> handle_response()
  end

  @doc """
  Get location details (`GET .../locations/:location_id`).
  """
  def get(client, account_id, location_id) do
    c(client)
    |> Tesla.get(location_path(account_id, location_id))
    |> handle_response()
  end

  @doc """
  Update a location (`PUT .../locations/:location_id`).
  """
  def update(client, account_id, location_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(location_path(account_id, location_id), params)
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/gateway/locations"

  defp location_path(account_id, location_id),
    do: base_path(account_id) <> "/#{encode(location_id)}"

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
