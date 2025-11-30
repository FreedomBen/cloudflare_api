defmodule CloudflareApi.RadarRobotsTxt do
  @moduledoc ~S"""
  Radar robots.txt analytics under `/radar/robots_txt`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Top domain categories for radar robots txt.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarRobotsTxt.top_domain_categories(client, [])
      {:ok, %{"id" => "example"}}

  """

  def top_domain_categories(client, opts \\ []) do
    fetch(client, "/radar/robots_txt/top/domain_categories", opts)
  end

  @doc ~S"""
  Top user agents by directive for radar robots txt.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarRobotsTxt.top_user_agents_by_directive(client, [])
      {:ok, %{"id" => "example"}}

  """

  def top_user_agents_by_directive(client, opts \\ []) do
    fetch(client, "/radar/robots_txt/top/user_agents/directive", opts)
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
