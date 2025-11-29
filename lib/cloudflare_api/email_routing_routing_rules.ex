defmodule CloudflareApi.EmailRoutingRoutingRules do
  @moduledoc ~S"""
  Manage Email Routing rules via `/zones/:zone_id/email/routing/rules`.
  """

  @doc ~S"""
  List email routing routing rules.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailRoutingRoutingRules.list(client, "zone_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, zone_id) do
    request(client, :get, base(zone_id))
  end

  @doc ~S"""
  Create email routing routing rules.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailRoutingRoutingRules.create(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, zone_id, params) when is_map(params) do
    request(client, :post, base(zone_id), params)
  end

  @doc ~S"""
  Get email routing routing rules.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailRoutingRoutingRules.get(client, "zone_id", "rule_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, zone_id, rule_id) do
    request(client, :get, rule_path(zone_id, rule_id))
  end

  @doc ~S"""
  Update email routing routing rules.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailRoutingRoutingRules.update(client, "zone_id", "rule_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, zone_id, rule_id, params) when is_map(params) do
    request(client, :put, rule_path(zone_id, rule_id), params)
  end

  @doc ~S"""
  Delete email routing routing rules.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailRoutingRoutingRules.delete(client, "zone_id", "rule_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, zone_id, rule_id) do
    request(client, :delete, rule_path(zone_id, rule_id), %{})
  end

  @doc ~S"""
  Get catch all for email routing routing rules.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailRoutingRoutingRules.get_catch_all(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def get_catch_all(client, zone_id) do
    request(client, :get, base(zone_id) <> "/catch_all")
  end

  @doc ~S"""
  Update catch all for email routing routing rules.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailRoutingRoutingRules.update_catch_all(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_catch_all(client, zone_id, params) when is_map(params) do
    request(client, :put, base(zone_id) <> "/catch_all", params)
  end

  defp base(zone_id), do: "/zones/#{zone_id}/email/routing/rules"
  defp rule_path(zone_id, id), do: base(zone_id) <> "/#{id}"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:put, %{} = params} -> Tesla.put(client, url, params)
        {:delete, %{} = params} -> Tesla.delete(client, url, body: params)
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
