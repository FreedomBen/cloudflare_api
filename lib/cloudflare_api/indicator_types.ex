defmodule CloudflareApi.IndicatorTypes do
  @moduledoc ~S"""
  Indicator type helpers for Cloudforce One datasets.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List indicator types.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IndicatorTypes.list(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, opts \\ []) do
    request(
      client,
      "/accounts/#{account_id}/cloudforce-one/events/indicator-types" <> query_suffix(opts)
    )
  end

  @doc ~S"""
  List legacy for indicator types.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IndicatorTypes.list_legacy(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_legacy(client, account_id, opts \\ []) do
    request(
      client,
      "/accounts/#{account_id}/cloudforce-one/events/indicatorTypes" <> query_suffix(opts)
    )
  end

  @doc ~S"""
  Create indicator types.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IndicatorTypes.create(client, "account_id", "dataset_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, dataset_id, params) when is_map(params) do
    request(
      client,
      dataset_base(account_id, dataset_id) <> "/indicatorTypes/create",
      params
    )
  end

  defp dataset_base(account_id, dataset_id),
    do: "/accounts/#{account_id}/cloudforce-one/events/dataset/#{dataset_id}"

  defp query_suffix([]), do: ""
  defp query_suffix(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

  defp request(client, url, body \\ nil) do
    client = c(client)

    result =
      case body do
        nil -> Tesla.get(client, url)
        %{} = params -> Tesla.post(client, url, params)
      end

    handle_response(result)
  end

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
