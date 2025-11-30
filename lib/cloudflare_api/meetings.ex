defmodule CloudflareApi.Meetings do
  @moduledoc ~S"""
  Manage Realtime Kit meetings and participants (`/accounts/:account_id/realtime/kit/:app_id/meetings`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List meetings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Meetings.list(client, "account_id", "app_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, app_id, opts \\ []) do
    request(client, :get, meetings_path(account_id, app_id) <> query(opts))
  end

  @doc ~S"""
  Create meetings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Meetings.create(client, "account_id", "app_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, app_id, params) when is_map(params) do
    request(client, :post, meetings_path(account_id, app_id), params)
  end

  @doc ~S"""
  Get meetings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Meetings.get(client, "account_id", "app_id", "meeting_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, app_id, meeting_id) do
    request(client, :get, meeting_path(account_id, app_id, meeting_id))
  end

  @doc ~S"""
  Update meetings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Meetings.update(client, "account_id", "app_id", "meeting_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, app_id, meeting_id, params) when is_map(params) do
    request(client, :patch, meeting_path(account_id, app_id, meeting_id), params)
  end

  @doc ~S"""
  Replace meetings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Meetings.replace(client, "account_id", "app_id", "meeting_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def replace(client, account_id, app_id, meeting_id, params) when is_map(params) do
    request(client, :put, meeting_path(account_id, app_id, meeting_id), params)
  end

  @doc ~S"""
  List participants for meetings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Meetings.list_participants(client, "account_id", "app_id", "meeting_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_participants(client, account_id, app_id, meeting_id, opts \\ []) do
    request(
      client,
      :get,
      participants_path(account_id, app_id, meeting_id) <> query(opts)
    )
  end

  @doc ~S"""
  Add participant for meetings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Meetings.add_participant(client, "account_id", "app_id", "meeting_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def add_participant(client, account_id, app_id, meeting_id, params) when is_map(params) do
    request(client, :post, participants_path(account_id, app_id, meeting_id), params)
  end

  @doc ~S"""
  Get participant for meetings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Meetings.get_participant(client, "account_id", "app_id", "meeting_id", "participant_id")
      {:ok, %{"id" => "example"}}

  """

  def get_participant(client, account_id, app_id, meeting_id, participant_id) do
    request(
      client,
      :get,
      participant_path(account_id, app_id, meeting_id, participant_id)
    )
  end

  @doc ~S"""
  Update participant for meetings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Meetings.update_participant(client, "account_id", "app_id", "meeting_id", "participant_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_participant(client, account_id, app_id, meeting_id, participant_id, params)
      when is_map(params) do
    request(
      client,
      :patch,
      participant_path(account_id, app_id, meeting_id, participant_id),
      params
    )
  end

  @doc ~S"""
  Delete participant for meetings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Meetings.delete_participant(client, "account_id", "app_id", "meeting_id", "participant_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_participant(client, account_id, app_id, meeting_id, participant_id) do
    request(
      client,
      :delete,
      participant_path(account_id, app_id, meeting_id, participant_id)
    )
  end

  @doc ~S"""
  Regenerate participant token for meetings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Meetings.regenerate_participant_token(client, "account_id", "app_id", "meeting_id", "participant_id")
      {:ok, %{"id" => "example"}}

  """

  def regenerate_participant_token(client, account_id, app_id, meeting_id, participant_id) do
    request(
      client,
      :post,
      participant_path(account_id, app_id, meeting_id, participant_id) <> "/token",
      %{}
    )
  end

  defp meetings_path(account_id, app_id),
    do: "/accounts/#{account_id}/realtime/kit/#{app_id}/meetings"

  defp meeting_path(account_id, app_id, meeting_id),
    do: meetings_path(account_id, app_id) <> "/#{meeting_id}"

  defp participants_path(account_id, app_id, meeting_id),
    do: meeting_path(account_id, app_id, meeting_id) <> "/participants"

  defp participant_path(account_id, app_id, meeting_id, participant_id),
    do: participants_path(account_id, app_id, meeting_id) <> "/#{participant_id}"

  defp query([]), do: ""
  defp query(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:put, %{} = params} -> Tesla.put(client, url, params)
        {:patch, %{} = params} -> Tesla.patch(client, url, params)
        {:delete, _} -> Tesla.delete(client, url)
      end

    handle_response(result)
  end

  defp handle_response({:ok, %Tesla.Env{status: 204}}), do: {:ok, :no_content}

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
