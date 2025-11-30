defmodule CloudflareApi.TokenValidationTokenRules do
  @moduledoc ~S"""
  Manage Token Validation rules via `/zones/:zone_id/token_validation/rules`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List token validation token rules.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.TokenValidationTokenRules.list(client, "zone_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base(zone_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create token validation token rules.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.TokenValidationTokenRules.create(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, zone_id, params) when is_map(params) or is_list(params) do
    c(client)
    |> Tesla.post(base(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Bulk create for token validation token rules.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.TokenValidationTokenRules.bulk_create(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def bulk_create(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(zone_id) <> "/bulk", params)
    |> handle_response()
  end

  @doc ~S"""
  Bulk update for token validation token rules.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.TokenValidationTokenRules.bulk_update(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def bulk_update(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(base(zone_id) <> "/bulk", params)
    |> handle_response()
  end

  @doc ~S"""
  Preview token validation token rules.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.TokenValidationTokenRules.preview(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def preview(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(zone_id) <> "/preview", params)
    |> handle_response()
  end

  @doc ~S"""
  Get token validation token rules.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.TokenValidationTokenRules.get(client, "zone_id", "rule_id", [])
      {:ok, %{"id" => "example"}}

  """

  def get(client, zone_id, rule_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(rule_path(zone_id, rule_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Update token validation token rules.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.TokenValidationTokenRules.update(client, "zone_id", "rule_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, zone_id, rule_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(rule_path(zone_id, rule_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete token validation token rules.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.TokenValidationTokenRules.delete(client, "zone_id", "rule_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, zone_id, rule_id) do
    c(client)
    |> Tesla.delete(rule_path(zone_id, rule_id), body: %{})
    |> handle_response()
  end

  defp base(zone_id), do: "/zones/#{zone_id}/token_validation/rules"

  defp rule_path(zone_id, rule_id), do: base(zone_id) <> "/#{encode(rule_id)}"

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
