defmodule CloudflareApi.Event do
  @moduledoc ~S"""
  Cloudforce One event helpers for `/accounts/:account_id/cloudforce-one/events`.
  """

  def list(client, account_id, opts \\ []) do
    get(client, account_id, "" <> query(opts))
  end

  def aggregate(client, account_id, opts \\ []) do
    get(client, account_id, "/aggregate" <> query(opts))
  end

  def create(client, account_id, params) when is_map(params) do
    post(client, account_id, "/create", params)
  end

  def create_bulk(client, account_id, params) when is_map(params) do
    post(client, account_id, "/create/bulk", params)
  end

  def create_bulk_with_relationships(client, account_id, params) when is_map(params) do
    post(client, account_id, "/create/bulk/relationships", params)
  end

  def get_event(client, account_id, dataset_id, event_id) do
    get(client, account_id, "/dataset/#{dataset_id}/events/#{event_id}")
  end

  def get_event_deprecated(client, account_id, event_id) do
    get(client, account_id, "/#{event_id}")
  end

  def update_event(client, account_id, event_id, params) when is_map(params) do
    patch(client, account_id, "/#{event_id}", params)
  end

  def update_event_post(client, account_id, event_id, params) when is_map(params) do
    post(client, account_id, "/#{event_id}", params)
  end

  def delete_event(client, account_id, event_id) do
    delete(client, account_id, "/#{event_id}", %{})
  end

  def delete_events_from_dataset(client, account_id, dataset_id, params) when is_map(params) do
    delete(client, account_id, "/#{dataset_id}/delete", params)
  end

  def move_to_dataset(client, account_id, dataset_id, params) when is_map(params) do
    post(client, account_id, "/dataset/#{dataset_id}/move", params)
  end

  def list_relationships(client, account_id, event_id, opts \\ []) do
    get(client, account_id, "/#{event_id}/relationships" <> query(opts))
  end

  def list_related(client, account_id, event_id) do
    get(client, account_id, "/relate/#{event_id}")
  end

  def create_relationship(client, account_id, event_id, params) when is_map(params) do
    post(client, account_id, "/relate/#{event_id}/create", params)
  end

  def delete_relationship(client, account_id, event_id) do
    delete(client, account_id, "/relate/#{event_id}", %{})
  end

  def create_relationships(client, account_id, params) when is_map(params) do
    post(client, account_id, "/relationships/create", params)
  end

  def add_event_tag(client, account_id, event_id, params) when is_map(params) do
    post(client, account_id, "/event_tag/#{event_id}/create", params)
  end

  def delete_event_tag(client, account_id, event_id) do
    delete(client, account_id, "/event_tag/#{event_id}", %{})
  end

  def get_raw_event(client, account_id, event_id, raw_id) do
    get(client, account_id, "/#{event_id}/raw/#{raw_id}")
  end

  def update_raw_event(client, account_id, event_id, raw_id, params) when is_map(params) do
    patch(client, account_id, "/#{event_id}/raw/#{raw_id}", params)
  end

  def update_raw_event_post(client, account_id, event_id, raw_id, params) when is_map(params) do
    post(client, account_id, "/#{event_id}/raw/#{raw_id}", params)
  end

  def get_raw_event_dataset(client, account_id, dataset_id, event_id) do
    get(client, account_id, "/raw/#{dataset_id}/#{event_id}")
  end

  def list_submissions(client, account_id, params) when is_map(params) do
    post(client, account_id, "/submissions", params)
  end

  defp base(account_id), do: "/accounts/#{account_id}/cloudforce-one/events"
  defp query([]), do: ""
  defp query(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

  defp get(client, account_id, path) do
    c(client)
    |> Tesla.get(base(account_id) <> path)
    |> handle()
  end

  defp post(client, account_id, path, params) do
    c(client)
    |> Tesla.post(base(account_id) <> path, params)
    |> handle()
  end

  defp patch(client, account_id, path, params) do
    c(client)
    |> Tesla.patch(base(account_id) <> path, params)
    |> handle()
  end

  defp delete(client, account_id, path, params) do
    c(client)
    |> Tesla.delete(base(account_id) <> path, body: params)
    |> handle()
  end

  defp handle({:ok, %Tesla.Env{status: status, body: %{"result" => result}}})
       when status in 200..299,
       do: {:ok, result}

  defp handle({:ok, %Tesla.Env{status: status, body: body}}) when status in 200..299,
    do: {:ok, body}

  defp handle({:ok, %Tesla.Env{body: %{"errors" => errors}}}), do: {:error, errors}
  defp handle(other), do: {:error, other}

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
