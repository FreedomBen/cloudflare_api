defmodule CloudflareApi.R2Bucket do
  @moduledoc ~S"""
  Manage R2 buckets, event notifications, domains, lifecycle policies, and
  temporary credentials under `/accounts/:account_id/r2`.
  """

  ## Buckets

  @doc ~S"""
  List r2 bucket.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2Bucket.list(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, opts \\ []) do
    request(client, :get, with_query(buckets_base(account_id), opts))
  end

  @doc ~S"""
  Create r2 bucket.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2Bucket.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, buckets_base(account_id), params)
  end

  @doc ~S"""
  Get r2 bucket.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2Bucket.get(client, "account_id", "bucket_name")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, bucket_name) do
    request(client, :get, bucket_path(account_id, bucket_name))
  end

  @doc ~S"""
  Patch r2 bucket.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2Bucket.patch(client, "account_id", "bucket_name", %{})
      {:ok, %{"id" => "example"}}

  """

  def patch(client, account_id, bucket_name, params) when is_map(params) do
    request(client, :patch, bucket_path(account_id, bucket_name), params)
  end

  @doc ~S"""
  Delete r2 bucket.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2Bucket.delete(client, "account_id", "bucket_name")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, bucket_name) do
    request(client, :delete, bucket_path(account_id, bucket_name))
  end

  ## CORS

  @doc ~S"""
  Get cors for r2 bucket.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2Bucket.get_cors(client, "account_id", "bucket_name")
      {:ok, %{"id" => "example"}}

  """

  def get_cors(client, account_id, bucket_name) do
    request(client, :get, cors_path(account_id, bucket_name))
  end

  @doc ~S"""
  Put cors for r2 bucket.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2Bucket.put_cors(client, "account_id", "bucket_name", %{})
      {:ok, %{"id" => "example"}}

  """

  def put_cors(client, account_id, bucket_name, params) when is_map(params) do
    request(client, :put, cors_path(account_id, bucket_name), params)
  end

  @doc ~S"""
  Delete cors for r2 bucket.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2Bucket.delete_cors(client, "account_id", "bucket_name")
      {:ok, %{"id" => "example"}}

  """

  def delete_cors(client, account_id, bucket_name) do
    request(client, :delete, cors_path(account_id, bucket_name))
  end

  ## Custom domains

  @doc ~S"""
  List custom domains for r2 bucket.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2Bucket.list_custom_domains(client, "account_id", "bucket_name")
      {:ok, [%{"id" => "example"}]}

  """

  def list_custom_domains(client, account_id, bucket_name) do
    request(client, :get, custom_domains_path(account_id, bucket_name))
  end

  @doc ~S"""
  Add custom domain for r2 bucket.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2Bucket.add_custom_domain(client, "account_id", "bucket_name", %{})
      {:ok, %{"id" => "example"}}

  """

  def add_custom_domain(client, account_id, bucket_name, params) when is_map(params) do
    request(client, :post, custom_domains_path(account_id, bucket_name), params)
  end

  @doc ~S"""
  Get custom domain for r2 bucket.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2Bucket.get_custom_domain(client, "account_id", "bucket_name", "domain")
      {:ok, %{"id" => "example"}}

  """

  def get_custom_domain(client, account_id, bucket_name, domain) do
    request(client, :get, custom_domain_path(account_id, bucket_name, domain))
  end

  @doc ~S"""
  Update custom domain for r2 bucket.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2Bucket.update_custom_domain(client, "account_id", "bucket_name", "domain", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_custom_domain(client, account_id, bucket_name, domain, params) when is_map(params) do
    request(client, :put, custom_domain_path(account_id, bucket_name, domain), params)
  end

  @doc ~S"""
  Delete custom domain for r2 bucket.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2Bucket.delete_custom_domain(client, "account_id", "bucket_name", "domain")
      {:ok, %{"id" => "example"}}

  """

  def delete_custom_domain(client, account_id, bucket_name, domain) do
    request(client, :delete, custom_domain_path(account_id, bucket_name, domain))
  end

  @doc ~S"""
  Get managed domain policy for r2 bucket.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2Bucket.get_managed_domain_policy(client, "account_id", "bucket_name")
      {:ok, %{"id" => "example"}}

  """

  def get_managed_domain_policy(client, account_id, bucket_name) do
    request(client, :get, managed_domain_path(account_id, bucket_name))
  end

  @doc ~S"""
  Update managed domain policy for r2 bucket.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2Bucket.update_managed_domain_policy(client, "account_id", "bucket_name", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_managed_domain_policy(client, account_id, bucket_name, params) when is_map(params) do
    request(client, :put, managed_domain_path(account_id, bucket_name), params)
  end

  ## Lifecycle & Lock

  @doc ~S"""
  Get lifecycle for r2 bucket.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2Bucket.get_lifecycle(client, "account_id", "bucket_name")
      {:ok, %{"id" => "example"}}

  """

  def get_lifecycle(client, account_id, bucket_name) do
    request(client, :get, lifecycle_path(account_id, bucket_name))
  end

  @doc ~S"""
  Put lifecycle for r2 bucket.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2Bucket.put_lifecycle(client, "account_id", "bucket_name", %{})
      {:ok, %{"id" => "example"}}

  """

  def put_lifecycle(client, account_id, bucket_name, params) when is_map(params) do
    request(client, :put, lifecycle_path(account_id, bucket_name), params)
  end

  @doc ~S"""
  Get lock for r2 bucket.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2Bucket.get_lock(client, "account_id", "bucket_name")
      {:ok, %{"id" => "example"}}

  """

  def get_lock(client, account_id, bucket_name) do
    request(client, :get, lock_path(account_id, bucket_name))
  end

  @doc ~S"""
  Put lock for r2 bucket.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2Bucket.put_lock(client, "account_id", "bucket_name", %{})
      {:ok, %{"id" => "example"}}

  """

  def put_lock(client, account_id, bucket_name, params) when is_map(params) do
    request(client, :put, lock_path(account_id, bucket_name), params)
  end

  ## Sippy configuration

  @doc ~S"""
  Get sippy for r2 bucket.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2Bucket.get_sippy(client, "account_id", "bucket_name")
      {:ok, %{"id" => "example"}}

  """

  def get_sippy(client, account_id, bucket_name) do
    request(client, :get, sippy_path(account_id, bucket_name))
  end

  @doc ~S"""
  Put sippy for r2 bucket.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2Bucket.put_sippy(client, "account_id", "bucket_name", %{})
      {:ok, %{"id" => "example"}}

  """

  def put_sippy(client, account_id, bucket_name, params) when is_map(params) do
    request(client, :put, sippy_path(account_id, bucket_name), params)
  end

  @doc ~S"""
  Delete sippy for r2 bucket.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2Bucket.delete_sippy(client, "account_id", "bucket_name")
      {:ok, %{"id" => "example"}}

  """

  def delete_sippy(client, account_id, bucket_name) do
    request(client, :delete, sippy_path(account_id, bucket_name))
  end

  ## Event notifications

  @doc ~S"""
  Get event notifications for r2 bucket.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2Bucket.get_event_notifications(client, "account_id", "bucket_name")
      {:ok, %{"id" => "example"}}

  """

  def get_event_notifications(client, account_id, bucket_name) do
    request(client, :get, event_notifications_base(account_id, bucket_name))
  end

  @doc ~S"""
  Get event notification for r2 bucket.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2Bucket.get_event_notification(client, "account_id", "bucket_name", "queue_id")
      {:ok, %{"id" => "example"}}

  """

  def get_event_notification(client, account_id, bucket_name, queue_id) do
    request(client, :get, event_notification_path(account_id, bucket_name, queue_id))
  end

  @doc ~S"""
  Update event notification for r2 bucket.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2Bucket.update_event_notification(client, "account_id", "bucket_name", "queue_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_event_notification(client, account_id, bucket_name, queue_id, params)
      when is_map(params) do
    request(client, :put, event_notification_path(account_id, bucket_name, queue_id), params)
  end

  @doc ~S"""
  Delete event notification for r2 bucket.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2Bucket.delete_event_notification(client, "account_id", "bucket_name", "queue_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_event_notification(client, account_id, bucket_name, queue_id) do
    request(client, :delete, event_notification_path(account_id, bucket_name, queue_id))
  end

  ## Temp credentials

  @doc ~S"""
  Create temp credentials for r2 bucket.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2Bucket.create_temp_credentials(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_temp_credentials(client, account_id, params) when is_map(params) do
    request(client, :post, "/accounts/#{account_id}/r2/temp-access-credentials", params)
  end

  ## Helpers

  defp request(client_or_fun, method, url, body \\ nil) do
    client = c(client_or_fun)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:delete, nil} -> Tesla.delete(client, url, body: %{})
        {:delete, %{} = params} -> Tesla.delete(client, url, body: params)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:put, %{} = params} -> Tesla.put(client, url, params)
        {:patch, %{} = params} -> Tesla.patch(client, url, params)
      end

    handle_response(result)
  end

  defp buckets_base(account_id), do: "/accounts/#{account_id}/r2/buckets"

  defp bucket_path(account_id, bucket_name),
    do: buckets_base(account_id) <> "/#{encode(bucket_name)}"

  defp cors_path(account_id, bucket_name), do: bucket_path(account_id, bucket_name) <> "/cors"

  defp custom_domains_path(account_id, bucket_name),
    do: bucket_path(account_id, bucket_name) <> "/domains/custom"

  defp custom_domain_path(account_id, bucket_name, domain),
    do: custom_domains_path(account_id, bucket_name) <> "/#{encode(domain)}"

  defp managed_domain_path(account_id, bucket_name),
    do: bucket_path(account_id, bucket_name) <> "/domains/managed"

  defp lifecycle_path(account_id, bucket_name),
    do: bucket_path(account_id, bucket_name) <> "/lifecycle"

  defp lock_path(account_id, bucket_name), do: bucket_path(account_id, bucket_name) <> "/lock"
  defp sippy_path(account_id, bucket_name), do: bucket_path(account_id, bucket_name) <> "/sippy"

  defp event_notifications_base(account_id, bucket_name) do
    "/accounts/#{account_id}/event_notifications/r2/#{encode(bucket_name)}/configuration"
  end

  defp event_notification_path(account_id, bucket_name, queue_id) do
    event_notifications_base(account_id, bucket_name) <> "/queues/#{encode(queue_id)}"
  end

  defp with_query(path, []), do: path
  defp with_query(path, opts), do: path <> "?" <> CloudflareApi.uri_encode_opts(opts)

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

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
