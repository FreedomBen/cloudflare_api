defmodule CloudflareApi.AccessBookmarks do
  @moduledoc ~S"""
  Deprecated Access bookmark application endpoints.

  These remain for completeness but may be removed by Cloudflare in the future.
  """

  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(account_id, opts))
    |> handle_response()
  end

  def create(client, account_id, bookmark_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(bookmark_path(account_id, bookmark_id), params)
    |> handle_response()
  end

  def get(client, account_id, bookmark_id) do
    c(client)
    |> Tesla.get(bookmark_path(account_id, bookmark_id))
    |> handle_response()
  end

  def update(client, account_id, bookmark_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(bookmark_path(account_id, bookmark_id), params)
    |> handle_response()
  end

  def delete(client, account_id, bookmark_id) do
    c(client)
    |> Tesla.delete(bookmark_path(account_id, bookmark_id), body: %{})
    |> handle_response()
  end

  defp list_url(account_id, []), do: base_path(account_id)

  defp list_url(account_id, opts) do
    base_path(account_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/access/bookmarks"
  defp bookmark_path(account_id, bookmark_id), do: base_path(account_id) <> "/#{bookmark_id}"

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
