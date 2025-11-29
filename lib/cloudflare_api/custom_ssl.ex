defmodule CloudflareApi.CustomSsl do
  @moduledoc ~S"""
  Manage custom SSL certificates for a zone.
  """

  @doc ~S"""
  List custom ssl.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CustomSsl.list(client, "zone_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(base_path(zone_id) <> query_suffix(opts))
    |> handle_response()
  end

  @doc ~S"""
  Create custom ssl.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CustomSsl.create(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get custom ssl.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CustomSsl.get(client, "zone_id", "certificate_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, zone_id, certificate_id) do
    c(client)
    |> Tesla.get(item_path(zone_id, certificate_id))
    |> handle_response()
  end

  @doc ~S"""
  Update custom ssl.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CustomSsl.update(client, "zone_id", "certificate_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, zone_id, certificate_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(item_path(zone_id, certificate_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete custom ssl.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CustomSsl.delete(client, "zone_id", "certificate_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, zone_id, certificate_id) do
    c(client)
    |> Tesla.delete(item_path(zone_id, certificate_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Prioritize custom ssl.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CustomSsl.prioritize(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def prioritize(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(base_path(zone_id) <> "/prioritize", params)
    |> handle_response()
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/custom_certificates"
  defp item_path(zone_id, certificate_id), do: base_path(zone_id) <> "/#{certificate_id}"
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
