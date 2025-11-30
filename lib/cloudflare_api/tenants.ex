defmodule CloudflareApi.Tenants do
  @moduledoc ~S"""
  Expose tenant metadata from `/tenants/:tenant_id`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Retrieve tenant details (`GET /tenants/:tenant_id`).
  """
  def get(client, tenant_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base(tenant_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  List valid account types for a tenant (`GET /tenants/:tenant_id/account_types`).
  """
  def account_types(client, tenant_id, opts \\ []) do
    list(client, tenant_id, "/account_types", opts)
  end

  @doc ~S"""
  List tenant accounts (`GET /tenants/:tenant_id/accounts`).
  """
  def accounts(client, tenant_id, opts \\ []) do
    list(client, tenant_id, "/accounts", opts)
  end

  @doc ~S"""
  List tenant entitlements (`GET /tenants/:tenant_id/entitlements`).
  """
  def entitlements(client, tenant_id, opts \\ []) do
    list(client, tenant_id, "/entitlements", opts)
  end

  @doc ~S"""
  List tenant memberships (`GET /tenants/:tenant_id/memberships`).
  """
  def memberships(client, tenant_id, opts \\ []) do
    list(client, tenant_id, "/memberships", opts)
  end

  defp list(client_or_fun, tenant_id, suffix, opts) do
    c(client_or_fun)
    |> Tesla.get(with_query(base(tenant_id) <> suffix, opts))
    |> handle_response()
  end

  defp base(tenant_id), do: "/tenants/#{tenant_id}"

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
