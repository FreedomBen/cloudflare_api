defmodule CloudflareApi.Cnis do
  @moduledoc ~S"""
  Manage Cloudflare Network Interconnects (CNIs) for an account.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List cnis.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Cnis.list(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(account_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Create cnis.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Cnis.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get cnis.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Cnis.get(client, "account_id", "cni_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, cni_id) do
    c(client)
    |> Tesla.get(cni_path(account_id, cni_id))
    |> handle_response()
  end

  @doc ~S"""
  Update cnis.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Cnis.update(client, "account_id", "cni_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, cni_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(cni_path(account_id, cni_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete cnis.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Cnis.delete(client, "account_id", "cni_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, cni_id) do
    c(client)
    |> Tesla.delete(cni_path(account_id, cni_id), body: %{})
    |> handle_response()
  end

  defp list_url(account_id, []), do: base_path(account_id)

  defp list_url(account_id, opts),
    do: base_path(account_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)

  defp base_path(account_id), do: "/accounts/#{account_id}/cni/cnis"
  defp cni_path(account_id, cni_id), do: base_path(account_id) <> "/#{cni_id}"

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
