defmodule CloudflareApi.LogoMatch do
  @moduledoc ~S"""
  Manage logo uploads and matching for Brand Protection.
  """

  def list_logo_matches(client, account_id, opts \\ []) do
    get(client, account_id, "/logo-matches", opts)
  end

  def download_logo_matches(client, account_id, opts \\ []) do
    get(client, account_id, "/logo-matches/download", opts)
  end

  def list_logos(client, account_id, opts \\ []) do
    get(client, account_id, "/logos", opts)
  end

  def create_logo(client, account_id, params) when is_map(params) do
    post(client, account_id, "/logos", params)
  end

  def get_logo(client, account_id, logo_id) do
    get(client, account_id, "/logos/#{logo_id}", [])
  end

  def delete_logo(client, account_id, logo_id) do
    delete(client, account_id, "/logos/#{logo_id}", %{})
  end

  def scan_logo(client, account_id, params) when is_map(params) do
    post(client, account_id, "/scan-logo", params)
  end

  def scan_page(client, account_id, params) when is_map(params) do
    post(client, account_id, "/scan-page", params)
  end

  def signed_url(client, opts \\ []) do
    c(client)
    |> Tesla.get(with_query("/signed-url", opts))
    |> handle_response()
  end

  defp get(client, account_id, suffix, opts) do
    c(client)
    |> Tesla.get(with_query(base_path(account_id) <> suffix, opts))
    |> handle_response()
  end

  defp post(client, account_id, suffix, params) do
    c(client)
    |> Tesla.post(base_path(account_id) <> suffix, params)
    |> handle_response()
  end

  defp delete(client, account_id, suffix, params) do
    c(client)
    |> Tesla.delete(base_path(account_id) <> suffix, body: params)
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/brand-protection"

  defp with_query(url, []), do: url
  defp with_query(url, opts), do: url <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
