defmodule CloudflareApi.RadarVerifiedBots do
  @moduledoc ~S"""
  Radar verified bot analytics under `/radar/verified_bots`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Top bots for radar verified bots.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarVerifiedBots.top_bots(client, [])
      {:ok, %{"id" => "example"}}

  """

  def top_bots(client, opts \\ []) do
    fetch(client, "/radar/verified_bots/top/bots", opts)
  end

  @doc ~S"""
  Top categories for radar verified bots.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarVerifiedBots.top_categories(client, [])
      {:ok, %{"id" => "example"}}

  """

  def top_categories(client, opts \\ []) do
    fetch(client, "/radar/verified_bots/top/categories", opts)
  end

  defp fetch(client_or_fun, path, opts) do
    c(client_or_fun)
    |> Tesla.get(with_query(path, opts))
    |> handle_response()
  end

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
