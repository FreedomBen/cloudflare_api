defmodule CloudflareApi.PageRules do
  @moduledoc ~S"""
  Manage zone-level Page Rules (`/zones/:zone_id/pagerules`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List Page Rules (`GET /pagerules`).
  """
  def list(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(zone_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a Page Rule (`POST /pagerules`).
  """
  def create(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Retrieve a Page Rule (`GET /pagerules/:pagerule_id`).
  """
  def get(client, zone_id, pagerule_id) do
    c(client)
    |> Tesla.get(rule_path(zone_id, pagerule_id))
    |> handle_response()
  end

  @doc ~S"""
  Update a Page Rule (`PUT /pagerules/:pagerule_id`).
  """
  def update(client, zone_id, pagerule_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(rule_path(zone_id, pagerule_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Patch a Page Rule (`PATCH /pagerules/:pagerule_id`).
  """
  def patch(client, zone_id, pagerule_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(rule_path(zone_id, pagerule_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a Page Rule (`DELETE /pagerules/:pagerule_id`).
  """
  def delete(client, zone_id, pagerule_id) do
    c(client)
    |> Tesla.delete(rule_path(zone_id, pagerule_id), body: %{})
    |> handle_response()
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/pagerules"
  defp rule_path(zone_id, pagerule_id), do: base_path(zone_id) <> "/#{pagerule_id}"

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
