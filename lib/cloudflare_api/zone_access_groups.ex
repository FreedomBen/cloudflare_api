defmodule CloudflareApi.ZoneAccessGroups do
  @moduledoc ~S"""
  Manage Access groups scoped to a zone.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List Access groups (`GET /zones/:zone_id/access/groups`).
  """
  def list(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(zone_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create an Access group (`POST /zones/:zone_id/access/groups`).
  """
  def create(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Retrieve an Access group (`GET /zones/:zone_id/access/groups/:group_id`).
  """
  def get(client, zone_id, group_id) do
    c(client)
    |> Tesla.get(group_path(zone_id, group_id))
    |> handle_response()
  end

  @doc ~S"""
  Update an Access group (`PUT /zones/:zone_id/access/groups/:group_id`).
  """
  def update(client, zone_id, group_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(group_path(zone_id, group_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete an Access group (`DELETE /zones/:zone_id/access/groups/:group_id`).
  """
  def delete(client, zone_id, group_id) do
    c(client)
    |> Tesla.delete(group_path(zone_id, group_id), body: %{})
    |> handle_response()
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/access/groups"
  defp group_path(zone_id, group_id), do: base_path(zone_id) <> "/#{group_id}"

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
