defmodule CloudflareApi.CustomHostnames do
  @moduledoc ~S"""
  Manage custom hostnames for a zone.
  """

  @doc ~S"""
  List custom hostnames.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CustomHostnames.list(client, "zone_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(base_path(zone_id) <> query_suffix(opts))
    |> handle_response()
  end

  @doc ~S"""
  Create custom hostnames.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CustomHostnames.create(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get custom hostnames.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CustomHostnames.get(client, "zone_id", "hostname_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, zone_id, hostname_id) do
    c(client)
    |> Tesla.get(hostname_path(zone_id, hostname_id))
    |> handle_response()
  end

  @doc ~S"""
  Update custom hostnames.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CustomHostnames.update(client, "zone_id", "hostname_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, zone_id, hostname_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(hostname_path(zone_id, hostname_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete custom hostnames.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CustomHostnames.delete(client, "zone_id", "hostname_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, zone_id, hostname_id) do
    c(client)
    |> Tesla.delete(hostname_path(zone_id, hostname_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Delete certificate for custom hostnames.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CustomHostnames.delete_certificate(client, "zone_id", "hostname_id", "pack_id", "certificate_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_certificate(client, zone_id, hostname_id, pack_id, certificate_id) do
    c(client)
    |> Tesla.delete(
      certificate_path(zone_id, hostname_id, pack_id, certificate_id),
      body: %{}
    )
    |> handle_response()
  end

  @doc ~S"""
  Update certificate for custom hostnames.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CustomHostnames.update_certificate(client, "zone_id", "hostname_id", "pack_id", "certificate_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_certificate(client, zone_id, hostname_id, pack_id, certificate_id, params)
      when is_map(params) do
    c(client)
    |> Tesla.put(
      certificate_path(zone_id, hostname_id, pack_id, certificate_id),
      params
    )
    |> handle_response()
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/custom_hostnames"
  defp hostname_path(zone_id, hostname_id), do: base_path(zone_id) <> "/#{hostname_id}"

  defp certificate_path(zone_id, hostname_id, pack_id, certificate_id),
    do:
      "#{hostname_path(zone_id, hostname_id)}/certificate_pack/#{pack_id}/certificates/#{certificate_id}"

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
