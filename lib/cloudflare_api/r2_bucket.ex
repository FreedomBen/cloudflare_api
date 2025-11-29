defmodule CloudflareApi.R2Bucket do
  @moduledoc ~S"""
  Manage R2 buckets, event notifications, domains, lifecycle policies, and
  temporary credentials under `/accounts/:account_id/r2`.
  """

  ## Buckets

  def list(client, account_id, opts \\ []) do
    request(client, :get, with_query(buckets_base(account_id), opts))
  end

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, buckets_base(account_id), params)
  end

  def get(client, account_id, bucket_name) do
    request(client, :get, bucket_path(account_id, bucket_name))
  end

  def patch(client, account_id, bucket_name, params) when is_map(params) do
    request(client, :patch, bucket_path(account_id, bucket_name), params)
  end

  def delete(client, account_id, bucket_name) do
    request(client, :delete, bucket_path(account_id, bucket_name))
  end

  ## CORS

  def get_cors(client, account_id, bucket_name) do
    request(client, :get, cors_path(account_id, bucket_name))
  end

  def put_cors(client, account_id, bucket_name, params) when is_map(params) do
    request(client, :put, cors_path(account_id, bucket_name), params)
  end

  def delete_cors(client, account_id, bucket_name) do
    request(client, :delete, cors_path(account_id, bucket_name))
  end

  ## Custom domains

  def list_custom_domains(client, account_id, bucket_name) do
    request(client, :get, custom_domains_path(account_id, bucket_name))
  end

  def add_custom_domain(client, account_id, bucket_name, params) when is_map(params) do
    request(client, :post, custom_domains_path(account_id, bucket_name), params)
  end

  def get_custom_domain(client, account_id, bucket_name, domain) do
    request(client, :get, custom_domain_path(account_id, bucket_name, domain))
  end

  def update_custom_domain(client, account_id, bucket_name, domain, params) when is_map(params) do
    request(client, :put, custom_domain_path(account_id, bucket_name, domain), params)
  end

  def delete_custom_domain(client, account_id, bucket_name, domain) do
    request(client, :delete, custom_domain_path(account_id, bucket_name, domain))
  end

  def get_managed_domain_policy(client, account_id, bucket_name) do
    request(client, :get, managed_domain_path(account_id, bucket_name))
  end

  def update_managed_domain_policy(client, account_id, bucket_name, params) when is_map(params) do
    request(client, :put, managed_domain_path(account_id, bucket_name), params)
  end

  ## Lifecycle & Lock

  def get_lifecycle(client, account_id, bucket_name) do
    request(client, :get, lifecycle_path(account_id, bucket_name))
  end

  def put_lifecycle(client, account_id, bucket_name, params) when is_map(params) do
    request(client, :put, lifecycle_path(account_id, bucket_name), params)
  end

  def get_lock(client, account_id, bucket_name) do
    request(client, :get, lock_path(account_id, bucket_name))
  end

  def put_lock(client, account_id, bucket_name, params) when is_map(params) do
    request(client, :put, lock_path(account_id, bucket_name), params)
  end

  ## Sippy configuration

  def get_sippy(client, account_id, bucket_name) do
    request(client, :get, sippy_path(account_id, bucket_name))
  end

  def put_sippy(client, account_id, bucket_name, params) when is_map(params) do
    request(client, :put, sippy_path(account_id, bucket_name), params)
  end

  def delete_sippy(client, account_id, bucket_name) do
    request(client, :delete, sippy_path(account_id, bucket_name))
  end

  ## Event notifications

  def get_event_notifications(client, account_id, bucket_name) do
    request(client, :get, event_notifications_base(account_id, bucket_name))
  end

  def get_event_notification(client, account_id, bucket_name, queue_id) do
    request(client, :get, event_notification_path(account_id, bucket_name, queue_id))
  end

  def update_event_notification(client, account_id, bucket_name, queue_id, params)
      when is_map(params) do
    request(client, :put, event_notification_path(account_id, bucket_name, queue_id), params)
  end

  def delete_event_notification(client, account_id, bucket_name, queue_id) do
    request(client, :delete, event_notification_path(account_id, bucket_name, queue_id))
  end

  ## Temp credentials

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
