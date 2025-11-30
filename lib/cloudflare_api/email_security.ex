defmodule CloudflareApi.EmailSecurity do
  @moduledoc ~S"""
  Investigate and manage Email Security messages (`/accounts/:account_id/email-security`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List messages for email security.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecurity.list_messages(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_messages(client, account_id, opts \\ []) do
    get(client, account_id, "/investigate" <> query(opts))
  end

  @doc ~S"""
  Get message for email security.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecurity.get_message(client, "account_id", "postfix_id")
      {:ok, %{"id" => "example"}}

  """

  def get_message(client, account_id, postfix_id) do
    get(client, account_id, "/investigate/#{postfix_id}")
  end

  @doc ~S"""
  Get message detections for email security.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecurity.get_message_detections(client, "account_id", "postfix_id")
      {:ok, %{"id" => "example"}}

  """

  def get_message_detections(client, account_id, postfix_id) do
    get(client, account_id, "/investigate/#{postfix_id}/detections")
  end

  @doc ~S"""
  Get message preview for email security.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecurity.get_message_preview(client, "account_id", "postfix_id")
      {:ok, %{"id" => "example"}}

  """

  def get_message_preview(client, account_id, postfix_id) do
    get(client, account_id, "/investigate/#{postfix_id}/preview")
  end

  @doc ~S"""
  Get message raw for email security.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecurity.get_message_raw(client, "account_id", "postfix_id")
      {:ok, %{"id" => "example"}}

  """

  def get_message_raw(client, account_id, postfix_id) do
    get(client, account_id, "/investigate/#{postfix_id}/raw")
  end

  @doc ~S"""
  Get message trace for email security.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecurity.get_message_trace(client, "account_id", "postfix_id")
      {:ok, %{"id" => "example"}}

  """

  def get_message_trace(client, account_id, postfix_id) do
    get(client, account_id, "/investigate/#{postfix_id}/trace")
  end

  @doc ~S"""
  List submissions for email security.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecurity.list_submissions(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_submissions(client, account_id, opts \\ []) do
    get(client, account_id, "/submissions" <> query(opts))
  end

  @doc ~S"""
  Bulk move messages for email security.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecurity.bulk_move_messages(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def bulk_move_messages(client, account_id, params) when is_map(params) do
    post(client, account_id, "/investigate/move", params)
  end

  @doc ~S"""
  Move message for email security.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecurity.move_message(client, "account_id", "postfix_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def move_message(client, account_id, postfix_id, params) when is_map(params) do
    post(client, account_id, "/investigate/#{postfix_id}/move", params)
  end

  @doc ~S"""
  Preview messages for email security.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecurity.preview_messages(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def preview_messages(client, account_id, params) when is_map(params) do
    post(client, account_id, "/investigate/preview", params)
  end

  @doc ~S"""
  Release messages for email security.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecurity.release_messages(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def release_messages(client, account_id, params) when is_map(params) do
    post(client, account_id, "/investigate/release", params)
  end

  @doc ~S"""
  Reclassify message for email security.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecurity.reclassify_message(client, "account_id", "postfix_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def reclassify_message(client, account_id, postfix_id, params) when is_map(params) do
    post(client, account_id, "/investigate/#{postfix_id}/reclassify", params)
  end

  defp base(account_id), do: "/accounts/#{account_id}/email-security"

  defp get(client, account_id, path) do
    c(client)
    |> Tesla.get(base(account_id) <> path)
    |> handle_response()
  end

  defp post(client, account_id, path, params) do
    c(client)
    |> Tesla.post(base(account_id) <> path, params)
    |> handle_response()
  end

  defp query([]), do: ""
  defp query(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

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
