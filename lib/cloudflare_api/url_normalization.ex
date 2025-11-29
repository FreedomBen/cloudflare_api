defmodule CloudflareApi.UrlNormalization do
  @moduledoc ~S"""
  Access URL Normalization settings at `/zones/:zone_id/url_normalization`.
  """

  @doc ~S"""
  Get url normalization.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.UrlNormalization.get(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, zone_id) do
    c(client)
    |> Tesla.get(path(zone_id))
    |> handle_response()
  end

  @doc ~S"""
  Update url normalization.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.UrlNormalization.update(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete url normalization.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.UrlNormalization.delete(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, zone_id) do
    c(client)
    |> Tesla.delete(path(zone_id), body: %{})
    |> handle_response()
  end

  defp path(zone_id), do: "/zones/#{zone_id}/url_normalization"

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
