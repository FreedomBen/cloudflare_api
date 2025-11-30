defmodule CloudflareApi.Filters do
  @moduledoc ~S"""
  Firewall filter management helpers for `/zones/:zone_id/filters`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List filters for a zone (`GET /zones/:zone_id/filters`).

  Accepts the following optional filters via `opts`:

    * `:paused` - boolean flag to return only paused/unpaused filters.
    * `:expression` - case-insensitive substring to match inside the filter expression.
    * `:description` - case-insensitive substring to match in descriptions.
    * `:ref` - exact match on the short reference tag.
    * `:id` - filter identifier (string).
    * `:page` / `:per_page` - pagination controls.
  """
  def list(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(filters_path(zone_id) <> query_suffix(opts))
    |> handle_response()
  end

  @doc ~S"""
  Create one or more filters (`POST /zones/:zone_id/filters`).

  `filters` must be a list of maps matching the Cloudflare schema (expression,
  description, ref, paused).
  """
  def create(client, zone_id, filters) when is_list(filters) do
    c(client)
    |> Tesla.post(filters_path(zone_id), filters)
    |> handle_response()
  end

  @doc ~S"""
  Bulk-update filters (`PUT /zones/:zone_id/filters`).

  Provide a list of maps that include an `id` field plus the updated attributes.
  """
  def update_many(client, zone_id, filters) when is_list(filters) do
    c(client)
    |> Tesla.put(filters_path(zone_id), filters)
    |> handle_response()
  end

  @doc ~S"""
  Delete multiple filters (`DELETE /zones/:zone_id/filters`).

  `filter_ids` can be a single id (binary) or a list of ids. Cloudflare expects
  repeated `id` query parameters, which this function assembles automatically.
  """
  @spec delete_many(
          CloudflareApi.client(),
          String.t(),
          [String.t() | integer()] | String.t() | integer()
        ) :: CloudflareApi.result(term()) | {:error, :no_filter_ids}
  def delete_many(client, zone_id, filter_ids)
      when is_list(filter_ids) and filter_ids != [] do
    query =
      filter_ids
      |> Enum.map(&{"id", to_string(&1)})
      |> CloudflareApi.uri_encode_opts()

    c(client)
    |> Tesla.delete(filters_path(zone_id) <> "?" <> query, body: %{})
    |> handle_response()
  end

  def delete_many(_client, _zone_id, []), do: {:error, :no_filter_ids}

  def delete_many(client, zone_id, filter_id) when is_binary(filter_id) do
    delete_many(client, zone_id, [filter_id])
  end

  def delete_many(client, zone_id, filter_id) when is_integer(filter_id) do
    delete_many(client, zone_id, [filter_id])
  end

  @doc ~S"""
  Retrieve a single filter (`GET /zones/:zone_id/filters/:filter_id`).
  """
  def get(client, zone_id, filter_id) do
    c(client)
    |> Tesla.get(filter_path(zone_id, filter_id))
    |> handle_response()
  end

  @doc ~S"""
  Update a single filter (`PUT /zones/:zone_id/filters/:filter_id`).
  """
  def update(client, zone_id, filter_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(filter_path(zone_id, filter_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a single filter (`DELETE /zones/:zone_id/filters/:filter_id`).
  """
  def delete(client, zone_id, filter_id) do
    c(client)
    |> Tesla.delete(filter_path(zone_id, filter_id), body: %{})
    |> handle_response()
  end

  defp filters_path(zone_id), do: "/zones/#{zone_id}/filters"
  defp filter_path(zone_id, filter_id), do: filters_path(zone_id) <> "/#{filter_id}"

  defp query_suffix([]), do: ""
  defp query_suffix(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

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
