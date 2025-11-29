defmodule CloudflareApi.AccessShortLivedCertificateCas do
  @moduledoc ~S"""
  Manage short-lived certificate CAs for Access applications.
  """

  @doc ~S"""
  List access short lived certificate cas.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessShortLivedCertificateCas.list(client, "account_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id) do
    c(client)
    |> Tesla.get("/accounts/#{account_id}/access/apps/ca")
    |> handle_response()
  end

  @doc ~S"""
  Create access short lived certificate cas.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessShortLivedCertificateCas.create(client, "account_id", "app_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, app_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(app_ca_path(account_id, app_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get access short lived certificate cas.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessShortLivedCertificateCas.get(client, "account_id", "app_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, app_id) do
    c(client)
    |> Tesla.get(app_ca_path(account_id, app_id))
    |> handle_response()
  end

  @doc ~S"""
  Delete access short lived certificate cas.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessShortLivedCertificateCas.delete(client, "account_id", "app_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, app_id) do
    c(client)
    |> Tesla.delete(app_ca_path(account_id, app_id), body: %{})
    |> handle_response()
  end

  defp app_ca_path(account_id, app_id), do: "/accounts/#{account_id}/access/apps/#{app_id}/ca"

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
