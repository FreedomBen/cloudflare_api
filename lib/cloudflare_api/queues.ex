defmodule CloudflareApi.Queues do
  @moduledoc ~S"""
  Manage Queues, consumers, subscriptions, and message operations under
  `/accounts/:account_id/queues` and `/event_subscriptions`.
  """

  use CloudflareApi.Typespecs

  ## Event Subscriptions

  @doc ~S"""
  List event subscriptions for an account (`GET /event_subscriptions/subscriptions`).
  """
  def list_subscriptions(client, account_id, opts \\ []) do
    request(client, :get, with_query(subscriptions_base(account_id), opts))
  end

  @doc ~S"""
  Create an event subscription (`POST /event_subscriptions/subscriptions`).
  """
  def create_subscription(client, account_id, params) when is_map(params) do
    request(client, :post, subscriptions_base(account_id), params)
  end

  @doc ~S"""
  Retrieve a subscription (`GET /event_subscriptions/subscriptions/:id`).
  """
  def get_subscription(client, account_id, subscription_id) do
    request(client, :get, subscription_path(account_id, subscription_id))
  end

  @doc ~S"""
  Update a subscription (`PATCH /event_subscriptions/subscriptions/:id`).
  """
  def update_subscription(client, account_id, subscription_id, params) when is_map(params) do
    request(client, :patch, subscription_path(account_id, subscription_id), params)
  end

  @doc ~S"""
  Delete a subscription (`DELETE /event_subscriptions/subscriptions/:id`).
  """
  def delete_subscription(client, account_id, subscription_id) do
    request(client, :delete, subscription_path(account_id, subscription_id))
  end

  ## Queues

  @doc ~S"""
  List queues (`GET /queues`).
  """
  def list(client, account_id, opts \\ []) do
    request(client, :get, with_query(queues_base(account_id), opts))
  end

  @doc ~S"""
  Create a queue (`POST /queues`).
  """
  def create(client, account_id, params) when is_map(params) do
    request(client, :post, queues_base(account_id), params)
  end

  @doc ~S"""
  Retrieve a queue (`GET /queues/:queue_id`).
  """
  def get(client, account_id, queue_id) do
    request(client, :get, queue_path(account_id, queue_id))
  end

  @doc ~S"""
  Replace a queue (`PUT /queues/:queue_id`).
  """
  def update(client, account_id, queue_id, params) when is_map(params) do
    request(client, :put, queue_path(account_id, queue_id), params)
  end

  @doc ~S"""
  Patch queue metadata (`PATCH /queues/:queue_id`).
  """
  def patch(client, account_id, queue_id, params) when is_map(params) do
    request(client, :patch, queue_path(account_id, queue_id), params)
  end

  @doc ~S"""
  Delete a queue (`DELETE /queues/:queue_id`).
  """
  def delete(client, account_id, queue_id) do
    request(client, :delete, queue_path(account_id, queue_id))
  end

  ## Consumers

  @doc ~S"""
  List consumers for a queue (`GET /queues/:queue_id/consumers`).
  """
  def list_consumers(client, account_id, queue_id, opts \\ []) do
    request(client, :get, with_query(consumers_path(account_id, queue_id), opts))
  end

  @doc ~S"""
  Create a consumer (`POST /queues/:queue_id/consumers`).
  """
  def create_consumer(client, account_id, queue_id, params) when is_map(params) do
    request(client, :post, consumers_path(account_id, queue_id), params)
  end

  @doc ~S"""
  Retrieve a consumer (`GET /queues/:queue_id/consumers/:consumer_id`).
  """
  def get_consumer(client, account_id, queue_id, consumer_id) do
    request(client, :get, consumer_path(account_id, queue_id, consumer_id))
  end

  @doc ~S"""
  Update a consumer (`PUT /queues/:queue_id/consumers/:consumer_id`).
  """
  def update_consumer(client, account_id, queue_id, consumer_id, params) when is_map(params) do
    request(client, :put, consumer_path(account_id, queue_id, consumer_id), params)
  end

  @doc ~S"""
  Delete a consumer (`DELETE /queues/:queue_id/consumers/:consumer_id`).
  """
  def delete_consumer(client, account_id, queue_id, consumer_id) do
    request(client, :delete, consumer_path(account_id, queue_id, consumer_id))
  end

  ## Messages

  @doc ~S"""
  Push a message (`POST /queues/:queue_id/messages`).
  """
  def push_message(client, account_id, queue_id, params) when is_map(params) do
    request(client, :post, messages_path(account_id, queue_id), params)
  end

  @doc ~S"""
  Push a batch of messages (`POST /queues/:queue_id/messages/batch`).
  """
  def push_messages(client, account_id, queue_id, params) when is_map(params) do
    request(client, :post, messages_path(account_id, queue_id) <> "/batch", params)
  end

  @doc ~S"""
  Acknowledge messages (`POST /queues/:queue_id/messages/ack`).
  """
  def ack_messages(client, account_id, queue_id, params) when is_map(params) do
    request(client, :post, messages_path(account_id, queue_id) <> "/ack", params)
  end

  @doc ~S"""
  Pull messages (`POST /queues/:queue_id/messages/pull`).
  """
  def pull_messages(client, account_id, queue_id, params) when is_map(params) do
    request(client, :post, messages_path(account_id, queue_id) <> "/pull", params)
  end

  ## Purge

  @doc ~S"""
  Get purge status (`GET /queues/:queue_id/purge`).
  """
  def get_purge_status(client, account_id, queue_id) do
    request(client, :get, purge_path(account_id, queue_id))
  end

  @doc ~S"""
  Trigger a purge (`POST /queues/:queue_id/purge`).
  """
  def purge(client, account_id, queue_id, params \\ %{}) when is_map(params) do
    request(client, :post, purge_path(account_id, queue_id), params)
  end

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

  defp subscriptions_base(account_id),
    do: "/accounts/#{account_id}/event_subscriptions/subscriptions"

  defp subscription_path(account_id, subscription_id),
    do: subscriptions_base(account_id) <> "/#{encode(subscription_id)}"

  defp queues_base(account_id), do: "/accounts/#{account_id}/queues"
  defp queue_path(account_id, queue_id), do: queues_base(account_id) <> "/#{encode(queue_id)}"
  defp consumers_path(account_id, queue_id), do: queue_path(account_id, queue_id) <> "/consumers"

  defp consumer_path(account_id, queue_id, consumer_id),
    do: consumers_path(account_id, queue_id) <> "/#{encode(consumer_id)}"

  defp messages_path(account_id, queue_id), do: queue_path(account_id, queue_id) <> "/messages"
  defp purge_path(account_id, queue_id), do: queue_path(account_id, queue_id) <> "/purge"

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
