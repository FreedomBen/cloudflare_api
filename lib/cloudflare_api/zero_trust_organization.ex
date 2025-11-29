defmodule CloudflareApi.ZeroTrustOrganization do
  @moduledoc ~S"""
  Manage Zero Trust organizations (`/accounts/:account_id/access/organizations`).
  """

  @doc """
  Fetch organization (`GET /accounts/:account_id/access/organizations`).
  """
  def get(client, account_id) do
    c(client)
    |> Tesla.get(base_path(account_id))
    |> handle_response()
  end

  @doc """
  Create organization (`POST /accounts/:account_id/access/organizations`).
  """
  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc """
  Update organization (`PUT /accounts/:account_id/access/organizations`).
  """
  def update(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(base_path(account_id), params)
    |> handle_response()
  end

  @doc """
  Get organization DoH settings (`GET .../organizations/doh`).
  """
  def get_doh_settings(client, account_id) do
    c(client)
    |> Tesla.get(doh_path(account_id))
    |> handle_response()
  end

  @doc """
  Update organization DoH settings (`PUT .../organizations/doh`).
  """
  def update_doh_settings(client, account_id, params \\ %{}) do
    c(client)
    |> Tesla.put(doh_path(account_id), params)
    |> handle_response()
  end

  @doc """
  Revoke all access tokens for a user (`POST .../organizations/revoke_user`).

  Optional query `:devices` controls whether to revoke device tokens.
  """
  def revoke_user(client, account_id, params, opts \\ []) when is_map(params) do
    c(client)
    |> Tesla.post(with_query(revoke_path(account_id), opts), params)
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/access/organizations"

  defp doh_path(account_id), do: base_path(account_id) <> "/doh"
  defp revoke_path(account_id), do: base_path(account_id) <> "/revoke_user"

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
