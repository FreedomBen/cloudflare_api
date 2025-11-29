defmodule CloudflareApi.Turnstile do
  @moduledoc ~S"""
  Manage Turnstile widgets under `/accounts/:account_id/challenges/widgets`.
  """

  @doc ~S"""
  List turnstile.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Turnstile.list(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base(account_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create turnstile.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Turnstile.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get turnstile.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Turnstile.get(client, "account_id", "site_key", [])
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, site_key, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(widget_path(account_id, site_key), opts))
    |> handle_response()
  end

  @doc ~S"""
  Update turnstile.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Turnstile.update(client, "account_id", "site_key", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, site_key, params) when is_map(params) do
    c(client)
    |> Tesla.put(widget_path(account_id, site_key), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete turnstile.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Turnstile.delete(client, "account_id", "site_key")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, site_key) do
    c(client)
    |> Tesla.delete(widget_path(account_id, site_key), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Rotate secret for turnstile.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Turnstile.rotate_secret(client, "account_id", "site_key", %{})
      {:ok, %{"id" => "example"}}

  """

  def rotate_secret(client, account_id, site_key, params \\ %{}) do
    c(client)
    |> Tesla.post(widget_path(account_id, site_key) <> "/rotate_secret", params)
    |> handle_response()
  end

  defp base(account_id), do: "/accounts/#{account_id}/challenges/widgets"

  defp widget_path(account_id, site_key) do
    base(account_id) <> "/#{encode(site_key)}"
  end

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

  defp with_query(path, []), do: path
  defp with_query(path, opts), do: path <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
