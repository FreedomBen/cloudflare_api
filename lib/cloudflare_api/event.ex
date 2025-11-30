defmodule CloudflareApi.Event do
  @moduledoc ~S"""
  Cloudforce One event helpers for `/accounts/:account_id/cloudforce-one/events`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List event.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Event.list(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, opts \\ []) do
    get(client, account_id, "" <> query(opts))
  end

  @doc ~S"""
  Aggregate event.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Event.aggregate(client, "account_id", [])
      {:ok, %{"id" => "example"}}

  """

  def aggregate(client, account_id, opts \\ []) do
    get(client, account_id, "/aggregate" <> query(opts))
  end

  @doc ~S"""
  Create event.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Event.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    post(client, account_id, "/create", params)
  end

  @doc ~S"""
  Create bulk for event.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Event.create_bulk(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_bulk(client, account_id, params) when is_map(params) do
    post(client, account_id, "/create/bulk", params)
  end

  @doc ~S"""
  Create bulk with relationships for event.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Event.create_bulk_with_relationships(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_bulk_with_relationships(client, account_id, params) when is_map(params) do
    post(client, account_id, "/create/bulk/relationships", params)
  end

  @doc ~S"""
  Get event for event.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Event.get_event(client, "account_id", "dataset_id", "event_id")
      {:ok, %{"id" => "example"}}

  """

  def get_event(client, account_id, dataset_id, event_id) do
    get(client, account_id, "/dataset/#{dataset_id}/events/#{event_id}")
  end

  @doc ~S"""
  Get event deprecated for event.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Event.get_event_deprecated(client, "account_id", "event_id")
      {:ok, %{"id" => "example"}}

  """

  def get_event_deprecated(client, account_id, event_id) do
    get(client, account_id, "/#{event_id}")
  end

  @doc ~S"""
  Update event for event.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Event.update_event(client, "account_id", "event_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_event(client, account_id, event_id, params) when is_map(params) do
    patch(client, account_id, "/#{event_id}", params)
  end

  @doc ~S"""
  Update event post for event.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Event.update_event_post(client, "account_id", "event_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_event_post(client, account_id, event_id, params) when is_map(params) do
    post(client, account_id, "/#{event_id}", params)
  end

  @doc ~S"""
  Delete event for event.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Event.delete_event(client, "account_id", "event_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_event(client, account_id, event_id) do
    delete(client, account_id, "/#{event_id}", %{})
  end

  @doc ~S"""
  Delete events from dataset for event.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Event.delete_events_from_dataset(client, "account_id", "dataset_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def delete_events_from_dataset(client, account_id, dataset_id, params) when is_map(params) do
    delete(client, account_id, "/#{dataset_id}/delete", params)
  end

  @doc ~S"""
  Move to dataset for event.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Event.move_to_dataset(client, "account_id", "dataset_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def move_to_dataset(client, account_id, dataset_id, params) when is_map(params) do
    post(client, account_id, "/dataset/#{dataset_id}/move", params)
  end

  @doc ~S"""
  List relationships for event.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Event.list_relationships(client, "account_id", "event_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_relationships(client, account_id, event_id, opts \\ []) do
    get(client, account_id, "/#{event_id}/relationships" <> query(opts))
  end

  @doc ~S"""
  List related for event.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Event.list_related(client, "account_id", "event_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list_related(client, account_id, event_id) do
    get(client, account_id, "/relate/#{event_id}")
  end

  @doc ~S"""
  Create relationship for event.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Event.create_relationship(client, "account_id", "event_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_relationship(client, account_id, event_id, params) when is_map(params) do
    post(client, account_id, "/relate/#{event_id}/create", params)
  end

  @doc ~S"""
  Delete relationship for event.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Event.delete_relationship(client, "account_id", "event_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_relationship(client, account_id, event_id) do
    delete(client, account_id, "/relate/#{event_id}", %{})
  end

  @doc ~S"""
  Create relationships for event.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Event.create_relationships(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_relationships(client, account_id, params) when is_map(params) do
    post(client, account_id, "/relationships/create", params)
  end

  @doc ~S"""
  Add event tag for event.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Event.add_event_tag(client, "account_id", "event_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def add_event_tag(client, account_id, event_id, params) when is_map(params) do
    post(client, account_id, "/event_tag/#{event_id}/create", params)
  end

  @doc ~S"""
  Delete event tag for event.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Event.delete_event_tag(client, "account_id", "event_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_event_tag(client, account_id, event_id) do
    delete(client, account_id, "/event_tag/#{event_id}", %{})
  end

  @doc ~S"""
  Get raw event for event.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Event.get_raw_event(client, "account_id", "event_id", "raw_id")
      {:ok, %{"id" => "example"}}

  """

  def get_raw_event(client, account_id, event_id, raw_id) do
    get(client, account_id, "/#{event_id}/raw/#{raw_id}")
  end

  @doc ~S"""
  Update raw event for event.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Event.update_raw_event(client, "account_id", "event_id", "raw_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_raw_event(client, account_id, event_id, raw_id, params) when is_map(params) do
    patch(client, account_id, "/#{event_id}/raw/#{raw_id}", params)
  end

  @doc ~S"""
  Update raw event post for event.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Event.update_raw_event_post(client, "account_id", "event_id", "raw_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_raw_event_post(client, account_id, event_id, raw_id, params) when is_map(params) do
    post(client, account_id, "/#{event_id}/raw/#{raw_id}", params)
  end

  @doc ~S"""
  Get raw event dataset for event.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Event.get_raw_event_dataset(client, "account_id", "dataset_id", "event_id")
      {:ok, %{"id" => "example"}}

  """

  def get_raw_event_dataset(client, account_id, dataset_id, event_id) do
    get(client, account_id, "/raw/#{dataset_id}/#{event_id}")
  end

  @doc ~S"""
  List submissions for event.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Event.list_submissions(client, "account_id", %{})
      {:ok, [%{"id" => "example"}]}

  """

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
