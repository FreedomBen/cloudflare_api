defmodule CloudflareApi.ZoneSnippets do
  @moduledoc ~S"""
  Manage zone Workers snippets and snippet rules.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List zone snippets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneSnippets.list(client, "zone_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(zone_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Get zone snippets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneSnippets.get(client, "zone_id", "snippet_name")
      {:ok, %{"id" => "example"}}

  """

  def get(client, zone_id, snippet_name) do
    c(client)
    |> Tesla.get(snippet_path(zone_id, snippet_name))
    |> handle_response()
  end

  @doc ~S"""
  Put zone snippets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneSnippets.put(client, "zone_id", "snippet_name", %{})
      {:ok, %{"id" => "example"}}

  """

  def put(client, zone_id, snippet_name, params) when is_map(params) do
    c(client)
    |> Tesla.put(snippet_path(zone_id, snippet_name), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete zone snippets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneSnippets.delete(client, "zone_id", "snippet_name")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, zone_id, snippet_name) do
    c(client)
    |> Tesla.delete(snippet_path(zone_id, snippet_name), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Get content for zone snippets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneSnippets.get_content(client, "zone_id", "snippet_name")
      {:ok, %{"id" => "example"}}

  """

  def get_content(client, zone_id, snippet_name) do
    c(client)
    |> Tesla.get(snippet_content_path(zone_id, snippet_name))
    |> handle_response()
  end

  @doc ~S"""
  List rules for zone snippets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneSnippets.list_rules(client, "zone_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list_rules(client, zone_id) do
    c(client)
    |> Tesla.get(rules_path(zone_id))
    |> handle_response()
  end

  @doc ~S"""
  Update rules for zone snippets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneSnippets.update_rules(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_rules(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(rules_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete rules for zone snippets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneSnippets.delete_rules(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_rules(client, zone_id) do
    c(client)
    |> Tesla.delete(rules_path(zone_id), body: %{})
    |> handle_response()
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/snippets"
  defp snippet_path(zone_id, snippet_name), do: base_path(zone_id) <> "/#{snippet_name}"

  defp snippet_content_path(zone_id, snippet_name),
    do: snippet_path(zone_id, snippet_name) <> "/content"

  defp rules_path(zone_id), do: base_path(zone_id) <> "/snippet_rules"

  defp with_query(url, []), do: url
  defp with_query(url, opts), do: url <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
