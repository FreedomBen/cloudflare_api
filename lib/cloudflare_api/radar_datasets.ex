defmodule CloudflareApi.RadarDatasets do
  @moduledoc ~S"""
  Access Radar datasets under `/radar/datasets`.
  """

  @doc ~S"""
  List radar datasets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarDatasets.list(client, [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, opts \\ []) do
    fetch(client, "/radar/datasets", opts)
  end

  @doc ~S"""
  Get radar datasets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarDatasets.get(client, "alias", [])
      {:ok, %{"id" => "example"}}

  """

  def get(client, alias, opts \\ []) do
    fetch(client, "/radar/datasets/" <> encode(alias), opts)
  end

  @doc ~S"""
  Request download url for radar datasets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarDatasets.request_download_url(client, %{})
      {:ok, %{"id" => "example"}}

  """

  def request_download_url(client, params) when is_map(params) do
    c(client)
    |> Tesla.post("/radar/datasets/download", params)
    |> handle_response()
  end

  defp fetch(client_or_fun, path, opts) do
    c(client_or_fun)
    |> Tesla.get(with_query(path, opts))
    |> handle_response()
  end

  defp with_query(path, []), do: path
  defp with_query(path, opts), do: path <> "?" <> CloudflareApi.uri_encode_opts(opts)

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

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
