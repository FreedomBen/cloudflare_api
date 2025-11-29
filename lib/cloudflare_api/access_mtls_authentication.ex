defmodule CloudflareApi.AccessMtlsAuthentication do
  @moduledoc ~S"""
  Manage Access mTLS certificates and hostname settings for an account.
  """

  def list_certificates(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(account_id, opts))
    |> handle_response()
  end

  def create_certificate(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  def get_certificate(client, account_id, certificate_id) do
    c(client)
    |> Tesla.get(cert_path(account_id, certificate_id))
    |> handle_response()
  end

  def update_certificate(client, account_id, certificate_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(cert_path(account_id, certificate_id), params)
    |> handle_response()
  end

  def delete_certificate(client, account_id, certificate_id) do
    c(client)
    |> Tesla.delete(cert_path(account_id, certificate_id), body: %{})
    |> handle_response()
  end

  def get_settings(client, account_id) do
    c(client)
    |> Tesla.get(settings_path(account_id))
    |> handle_response()
  end

  def update_settings(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(settings_path(account_id), params)
    |> handle_response()
  end

  defp list_url(account_id, []), do: base_path(account_id)

  defp list_url(account_id, opts) do
    base_path(account_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/access/certificates"
  defp cert_path(account_id, certificate_id), do: base_path(account_id) <> "/#{certificate_id}"
  defp settings_path(account_id), do: base_path(account_id) <> "/settings"

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
