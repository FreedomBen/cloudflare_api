defmodule CloudflareApi.DevicesResilience do
  @moduledoc ~S"""
  Manage global WARP override state via `/accounts/:account_id/devices/resilience/disconnect`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Get override for devices resilience.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DevicesResilience.get_override(client, "account_id")
      {:ok, %{"id" => "example"}}

  """

  def get_override(client, account_id) do
    c(client)
    |> Tesla.get(base(account_id))
    |> handle()
  end

  @doc ~S"""
  Set override for devices resilience.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DevicesResilience.set_override(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def set_override(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(account_id), params)
    |> handle()
  end

  defp base(account_id), do: "/accounts/#{account_id}/devices/resilience/disconnect"

  defp handle({:ok, %Tesla.Env{status: status, body: %{"result" => result}}})
       when status in 200..299,
       do: {:ok, result}

  defp handle({:ok, %Tesla.Env{status: status, body: body}}) when status in 200..299,
    do: {:ok, body}

  defp handle({:ok, %Tesla.Env{body: %{"errors" => errors}}}), do: {:error, errors}
  defp handle(other), do: {:error, other}

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
