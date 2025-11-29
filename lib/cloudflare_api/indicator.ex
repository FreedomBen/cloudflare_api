defmodule CloudflareApi.Indicator do
  @moduledoc ~S"""
  Cloudforce One indicator helpers.
  """

  def list(client, account_id, dataset_id, opts \\ []) do
    request(client, :get, indicators_path(account_id, dataset_id) <> query_suffix(opts))
  end

  def list_all(client, account_id, opts \\ []) do
    request(
      client,
      :get,
      "/accounts/#{account_id}/cloudforce-one/events/indicators" <> query_suffix(opts)
    )
  end

  def list_tags(client, account_id, dataset_id, opts \\ []) do
    request(
      client,
      :get,
      dataset_base(account_id, dataset_id) <> "/indicators/tags" <> query_suffix(opts)
    )
  end

  def create(client, account_id, dataset_id, params) when is_map(params) do
    request(client, :post, dataset_base(account_id, dataset_id) <> "/indicators/create", params)
  end

  def create_bulk(client, account_id, dataset_id, params) when is_map(params) do
    request(client, :post, dataset_base(account_id, dataset_id) <> "/indicators/bulk", params)
  end

  def get(client, account_id, dataset_id, indicator_id) do
    request(
      client,
      :get,
      dataset_base(account_id, dataset_id) <> "/indicators/#{indicator_id}"
    )
  end

  def update(client, account_id, dataset_id, indicator_id, params) when is_map(params) do
    request(
      client,
      :patch,
      dataset_base(account_id, dataset_id) <> "/indicators/#{indicator_id}",
      params
    )
  end

  def delete(client, account_id, dataset_id, indicator_id) do
    request(
      client,
      :delete,
      dataset_base(account_id, dataset_id) <> "/indicators/#{indicator_id}",
      %{}
    )
  end

  defp dataset_base(account_id, dataset_id),
    do: "/accounts/#{account_id}/cloudforce-one/events/dataset/#{dataset_id}"

  defp indicators_path(account_id, dataset_id),
    do: dataset_base(account_id, dataset_id) <> "/indicators"

  defp query_suffix([]), do: ""
  defp query_suffix(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} ->
          Tesla.get(client, url)

        {:post, %{} = params} ->
          Tesla.post(client, url, params)

        {:patch, %{} = params} ->
          Tesla.patch(client, url, params)

        {:delete, %{} = params} ->
          Tesla.delete(client, url, body: params)
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
