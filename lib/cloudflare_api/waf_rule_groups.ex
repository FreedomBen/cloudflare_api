defmodule CloudflareApi.WafRuleGroups do
  @moduledoc ~S"""
  Manage WAF rule groups at
  `/zones/:zone_id/firewall/waf/packages/:package_id/groups`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List waf rule groups.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.WafRuleGroups.list(client, "zone_id", "package_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, zone_id, package_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base(zone_id, package_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Get waf rule groups.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.WafRuleGroups.get(client, "zone_id", "package_id", "group_id", [])
      {:ok, %{"id" => "example"}}

  """

  def get(client, zone_id, package_id, group_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(group_path(zone_id, package_id, group_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Update waf rule groups.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.WafRuleGroups.update(client, "zone_id", "package_id", "group_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, zone_id, package_id, group_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(group_path(zone_id, package_id, group_id), params)
    |> handle_response()
  end

  defp base(zone_id, package_id),
    do: "/zones/#{zone_id}/firewall/waf/packages/#{encode(package_id)}/groups"

  defp group_path(zone_id, package_id, group_id) do
    base(zone_id, package_id) <> "/#{encode(group_id)}"
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
