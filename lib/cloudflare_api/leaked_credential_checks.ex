defmodule CloudflareApi.LeakedCredentialChecks do
  @moduledoc ~S"""
  Manage Cloudflare Leaked Credential Checks for a zone (`/zones/:zone_id/leaked-credential-checks`).
  """

  @doc ~S"""
  Get status for leaked credential checks.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LeakedCredentialChecks.get_status(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def get_status(client, zone_id) do
    request(client, :get, base_path(zone_id))
  end

  @doc ~S"""
  Set status for leaked credential checks.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LeakedCredentialChecks.set_status(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def set_status(client, zone_id, params) when is_map(params) do
    request(client, :post, base_path(zone_id), params)
  end

  @doc ~S"""
  List detections for leaked credential checks.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LeakedCredentialChecks.list_detections(client, "zone_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list_detections(client, zone_id) do
    request(client, :get, detections_path(zone_id))
  end

  @doc ~S"""
  Create detection for leaked credential checks.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LeakedCredentialChecks.create_detection(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_detection(client, zone_id, params) when is_map(params) do
    request(client, :post, detections_path(zone_id), params)
  end

  @doc ~S"""
  Get detection for leaked credential checks.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LeakedCredentialChecks.get_detection(client, "zone_id", "detection_id")
      {:ok, %{"id" => "example"}}

  """

  def get_detection(client, zone_id, detection_id) do
    request(client, :get, detection_path(zone_id, detection_id))
  end

  @doc ~S"""
  Update detection for leaked credential checks.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LeakedCredentialChecks.update_detection(client, "zone_id", "detection_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_detection(client, zone_id, detection_id, params) when is_map(params) do
    request(client, :put, detection_path(zone_id, detection_id), params)
  end

  @doc ~S"""
  Delete detection for leaked credential checks.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LeakedCredentialChecks.delete_detection(client, "zone_id", "detection_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_detection(client, zone_id, detection_id) do
    request(client, :delete, detection_path(zone_id, detection_id), %{})
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/leaked-credential-checks"
  defp detections_path(zone_id), do: base_path(zone_id) <> "/detections"
  defp detection_path(zone_id, detection_id), do: detections_path(zone_id) <> "/#{detection_id}"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:put, %{} = params} -> Tesla.put(client, url, params)
        {:delete, %{} = params} -> Tesla.delete(client, url, body: params)
      end

    handle_response(result)
  end

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
