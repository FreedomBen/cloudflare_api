defmodule CloudflareApi.MtlsCertificateManagement do
  @moduledoc ~S"""
  Account-level mTLS certificate management helpers.
  """

  def list_certificates(client, account_id, opts \\ []) do
    get(client, account_id, "", opts)
  end

  def upload_certificate(client, account_id, params) when is_map(params) do
    post(client, account_id, "", params)
  end

  def get_certificate(client, account_id, certificate_id) do
    get(client, account_id, "/#{certificate_id}", [])
  end

  def delete_certificate(client, account_id, certificate_id) do
    delete(client, account_id, "/#{certificate_id}", %{})
  end

  def list_associations(client, account_id, certificate_id, opts \\ []) do
    get(client, account_id, "/#{certificate_id}/associations", opts)
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

  defp base_path(account_id), do: "/accounts/#{account_id}/mtls_certificates"

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
