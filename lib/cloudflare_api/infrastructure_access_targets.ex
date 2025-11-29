defmodule CloudflareApi.InfrastructureAccessTargets do
  @moduledoc ~S"""
  Manage Access targets under `/accounts/:account_id/infrastructure/targets`.
  """

  @doc ~S"""
  List infrastructure access targets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.InfrastructureAccessTargets.list(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, opts \\ []) do
    request(client, :get, base_path(account_id) <> query_suffix(opts))
  end

  @doc ~S"""
  Create infrastructure access targets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.InfrastructureAccessTargets.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base_path(account_id), params)
  end

  @doc ~S"""
  Get infrastructure access targets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.InfrastructureAccessTargets.get(client, "account_id", "target_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, target_id) do
    request(client, :get, target_path(account_id, target_id))
  end

  @doc ~S"""
  Update infrastructure access targets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.InfrastructureAccessTargets.update(client, "account_id", "target_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, target_id, params) when is_map(params) do
    request(client, :put, target_path(account_id, target_id), params)
  end

  @doc ~S"""
  Delete infrastructure access targets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.InfrastructureAccessTargets.delete(client, "account_id", "target_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, target_id) do
    request(client, :delete, target_path(account_id, target_id), %{})
  end

  @doc ~S"""
  Create targets for infrastructure access targets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> targets = [%{}]
      iex> CloudflareApi.InfrastructureAccessTargets.create_targets(client, "account_id", targets)
      {:ok, %{"id" => "example"}}

  """

  def create_targets(client, account_id, targets) when is_list(targets) do
    request(client, :put, base_path(account_id) <> "/batch", targets)
  end

  @doc ~S"""
  Delete targets for infrastructure access targets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> target_ids = ["target_id"]
      iex> CloudflareApi.InfrastructureAccessTargets.delete_targets(client, "account_id", target_ids)
      {:ok, %{"id" => "example"}}

  """

  def delete_targets(client, account_id, target_ids) when is_list(target_ids) do
    request(client, :post, base_path(account_id) <> "/batch_delete", %{"target_ids" => target_ids})
  end

  @doc ~S"""
  Delete targets deprecated for infrastructure access targets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> targets = [%{}]
      iex> CloudflareApi.InfrastructureAccessTargets.delete_targets_deprecated(client, "account_id", targets)
      {:ok, %{"id" => "example"}}

  """

  def delete_targets_deprecated(client, account_id, targets) when is_list(targets) do
    request(client, :delete, base_path(account_id) <> "/batch", targets)
  end

  @doc ~S"""
  Get status for infrastructure access targets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.InfrastructureAccessTargets.get_status(client, "account_id", "target_id")
      {:ok, %{"id" => "example"}}

  """

  def get_status(client, account_id, target_id) do
    request(client, :get, target_path(account_id, target_id) <> "/status")
  end

  @doc ~S"""
  Get loa for infrastructure access targets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.InfrastructureAccessTargets.get_loa(client, "account_id", "target_id")
      {:ok, %{"id" => "example"}}

  """

  def get_loa(client, account_id, target_id) do
    c(client)
    |> Tesla.get(target_path(account_id, target_id) <> "/loa")
    |> handle_binary_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/infrastructure/targets"
  defp target_path(account_id, target_id), do: base_path(account_id) <> "/#{target_id}"

  defp query_suffix([]), do: ""
  defp query_suffix(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} ->
          Tesla.get(client, url)

        {:post, params} ->
          Tesla.post(client, url, params)

        {:put, params} ->
          Tesla.put(client, url, params)

        {:delete, params} ->
          Tesla.delete(client, url, body: params)
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

  defp handle_binary_response({:ok, %Tesla.Env{status: status, body: body}})
       when status in 200..299,
       do: {:ok, body}

  defp handle_binary_response({:ok, %Tesla.Env{body: %{"errors" => errors}}}),
    do: {:error, errors}

  defp handle_binary_response(other), do: {:error, other}

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
