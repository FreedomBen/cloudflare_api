defmodule CloudflareApi.R2CatalogManagement do
  @moduledoc ~S"""
  Manage R2 catalog buckets via `/accounts/:account_id/r2-catalog`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List R2 catalogs for an account.
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(account_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Fetch catalog details for a bucket.
  """
  def get(client, account_id, bucket_name) do
    c(client)
    |> Tesla.get(bucket_path(account_id, bucket_name))
    |> handle_response()
  end

  @doc ~S"""
  Enable cataloging for a bucket.
  """
  def enable(client, account_id, bucket_name) do
    c(client)
    |> Tesla.post(bucket_path(account_id, bucket_name) <> "/enable", %{})
    |> handle_response()
  end

  @doc ~S"""
  Disable cataloging for a bucket.
  """
  def disable(client, account_id, bucket_name) do
    c(client)
    |> Tesla.post(bucket_path(account_id, bucket_name) <> "/disable", %{})
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/r2-catalog"

  defp bucket_path(account_id, bucket_name),
    do: base_path(account_id) <> "/#{encode(bucket_name)}"

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
