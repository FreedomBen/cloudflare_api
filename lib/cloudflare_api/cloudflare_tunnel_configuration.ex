defmodule CloudflareApi.CloudflareTunnelConfiguration do
  @moduledoc ~S"""
  Manage configurations for Cloudflare Tunnels configured via Zero Trust.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Get cloudflare tunnel configuration.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CloudflareTunnelConfiguration.get(client, "account_id", "tunnel_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, tunnel_id) do
    c(client)
    |> Tesla.get(config_path(account_id, tunnel_id))
    |> handle_response()
  end

  @doc ~S"""
  Put cloudflare tunnel configuration.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CloudflareTunnelConfiguration.put(client, "account_id", "tunnel_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def put(client, account_id, tunnel_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(config_path(account_id, tunnel_id), params)
    |> handle_response()
  end

  defp config_path(account_id, tunnel_id),
    do: "/accounts/#{account_id}/cfd_tunnel/#{tunnel_id}/configurations"

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
