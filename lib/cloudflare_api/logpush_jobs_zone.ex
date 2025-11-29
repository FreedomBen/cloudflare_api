defmodule CloudflareApi.LogpushJobsZone do
  @moduledoc ~S"""
  Manage zone-level Logpush jobs, ownership challenges, and destination/origin validation.
  """

  @doc ~S"""
  List logpush jobs zone.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LogpushJobsZone.list(client, "zone_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, zone_id) do
    request(client, :get, jobs_path(zone_id))
  end

  @doc ~S"""
  Create logpush jobs zone.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LogpushJobsZone.create(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, zone_id, params) when is_map(params) do
    request(client, :post, jobs_path(zone_id), params)
  end

  @doc ~S"""
  Get logpush jobs zone.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LogpushJobsZone.get(client, "zone_id", "job_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, zone_id, job_id) do
    request(client, :get, job_path(zone_id, job_id))
  end

  @doc ~S"""
  Update logpush jobs zone.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LogpushJobsZone.update(client, "zone_id", "job_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, zone_id, job_id, params) when is_map(params) do
    request(client, :put, job_path(zone_id, job_id), params)
  end

  @doc ~S"""
  Delete logpush jobs zone.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LogpushJobsZone.delete(client, "zone_id", "job_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, zone_id, job_id) do
    request(client, :delete, job_path(zone_id, job_id), %{})
  end

  @doc ~S"""
  List dataset jobs for logpush jobs zone.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LogpushJobsZone.list_dataset_jobs(client, "zone_id", %{})
      {:ok, [%{"id" => "example"}]}

  """

  def list_dataset_jobs(client, zone_id, dataset_id) do
    request(client, :get, base(zone_id) <> "/datasets/#{dataset_id}/jobs")
  end

  @doc ~S"""
  List dataset fields for logpush jobs zone.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LogpushJobsZone.list_dataset_fields(client, "zone_id", %{})
      {:ok, [%{"id" => "example"}]}

  """

  def list_dataset_fields(client, zone_id, dataset_id) do
    request(client, :get, base(zone_id) <> "/datasets/#{dataset_id}/fields")
  end

  @doc ~S"""
  Ownership challenge for logpush jobs zone.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LogpushJobsZone.ownership_challenge(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def ownership_challenge(client, zone_id, params) when is_map(params) do
    request(client, :post, base(zone_id) <> "/ownership", params)
  end

  @doc ~S"""
  Validate ownership for logpush jobs zone.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LogpushJobsZone.validate_ownership(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def validate_ownership(client, zone_id, params) when is_map(params) do
    request(client, :post, base(zone_id) <> "/ownership/validate", params)
  end

  @doc ~S"""
  Validate destination for logpush jobs zone.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LogpushJobsZone.validate_destination(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def validate_destination(client, zone_id, params) when is_map(params) do
    request(client, :post, base(zone_id) <> "/validate/destination", params)
  end

  @doc ~S"""
  Destination exists for logpush jobs zone.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LogpushJobsZone.destination_exists?(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def destination_exists?(client, zone_id, params) when is_map(params) do
    request(client, :post, base(zone_id) <> "/validate/destination/exists", params)
  end

  @doc ~S"""
  Validate origin for logpush jobs zone.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LogpushJobsZone.validate_origin(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def validate_origin(client, zone_id, params) when is_map(params) do
    request(client, :post, base(zone_id) <> "/validate/origin", params)
  end

  defp base(zone_id), do: "/zones/#{zone_id}/logpush"
  defp jobs_path(zone_id), do: base(zone_id) <> "/jobs"
  defp job_path(zone_id, job_id), do: jobs_path(zone_id) <> "/#{job_id}"

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
