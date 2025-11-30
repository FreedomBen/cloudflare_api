defmodule CloudflareApi.SecondaryDnsSecondaryZone do
  @moduledoc ~S"""
  Manage secondary DNS *incoming* zone configurations under `/zones/:zone_id/secondary_dns`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Fetch the incoming/secondary configuration for a zone (`GET /secondary_dns/incoming`).
  """
  def get(client, zone_id, opts \\ []) do
    fetch(client, incoming_path(zone_id), opts)
  end

  @doc ~S"""
  Create a new incoming secondary configuration (`POST /secondary_dns/incoming`).
  """
  def create(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(incoming_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Update the incoming secondary configuration (`PUT /secondary_dns/incoming`).
  """
  def update(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(incoming_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete the incoming secondary configuration (`DELETE /secondary_dns/incoming`).
  """
  def delete(client, zone_id) do
    c(client)
    |> Tesla.delete(incoming_path(zone_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Force an AXFR transfer from the primary nameserver (`POST /secondary_dns/force_axfr`).
  """
  def force_axfr(client, zone_id) do
    c(client)
    |> Tesla.post(force_path(zone_id), %{})
    |> handle_response()
  end

  defp fetch(client_or_fun, path, opts) do
    c(client_or_fun)
    |> Tesla.get(with_query(path, opts))
    |> handle_response()
  end

  defp incoming_path(zone_id), do: "/zones/#{zone_id}/secondary_dns/incoming"
  defp force_path(zone_id), do: "/zones/#{zone_id}/secondary_dns/force_axfr"

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
