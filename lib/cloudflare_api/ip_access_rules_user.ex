defmodule CloudflareApi.IpAccessRulesUser do
  @moduledoc ~S"""
  User-level IP Access rules (`/user/firewall/access_rules/rules`).
  """

  @doc ~S"""
  List ip access rules user.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpAccessRulesUser.list(client, [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, opts \\ []) do
    request(client, :get, base_path() <> query_suffix(opts))
  end

  @doc ~S"""
  Create ip access rules user.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpAccessRulesUser.create(client, %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, params) when is_map(params) do
    request(client, :post, base_path(), params)
  end

  @doc ~S"""
  Update ip access rules user.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpAccessRulesUser.update(client, "rule_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, rule_id, params) when is_map(params) do
    request(client, :patch, item_path(rule_id), params)
  end

  @doc ~S"""
  Delete ip access rules user.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpAccessRulesUser.delete(client, "rule_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, rule_id) do
    request(client, :delete, item_path(rule_id), %{})
  end

  defp base_path, do: "/user/firewall/access_rules/rules"
  defp item_path(rule_id), do: base_path() <> "/#{rule_id}"

  defp query_suffix([]), do: ""
  defp query_suffix(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} ->
          Tesla.get(client, url)

        {:post, %{} = params} ->
          Tesla.post(client, url, params)

        {:patch, %{} = params} ->
          Tesla.patch(client, url, params)

        {:delete, %{} = params} ->
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

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
