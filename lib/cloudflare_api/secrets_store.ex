defmodule CloudflareApi.SecretsStore do
  @moduledoc ~S"""
  Account-level Secrets Store helper wrapping `/accounts/:account_id/secrets_store`.
  """

  @doc ~S"""
  Fetch usage/quota info (`GET /secrets_store/quota`).
  """
  def quota(client, account_id) do
    c(client)
    |> Tesla.get(quota_path(account_id))
    |> handle_response()
  end

  @doc ~S"""
  List stores within an account (`GET /secrets_store/stores`).
  """
  def list_stores(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(stores_path(account_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create one or more stores (`POST /secrets_store/stores`).
  """
  def create_stores(client, account_id, stores) when is_list(stores) or is_map(stores) do
    c(client)
    |> Tesla.post(stores_path(account_id), normalize_payload(stores))
    |> handle_response()
  end

  @doc ~S"""
  Delete a store (`DELETE /secrets_store/stores/:store_id`).
  """
  def delete_store(client, account_id, store_id) do
    c(client)
    |> Tesla.delete(store_path(account_id, store_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  List secrets in a store (`GET /secrets_store/stores/:store_id/secrets`).
  """
  def list_secrets(client, account_id, store_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(secrets_path(account_id, store_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create secrets (`POST /secrets_store/stores/:store_id/secrets`).
  """
  def create_secrets(client, account_id, store_id, secrets)
      when is_list(secrets) or is_map(secrets) do
    c(client)
    |> Tesla.post(secrets_path(account_id, store_id), normalize_payload(secrets))
    |> handle_response()
  end

  @doc ~S"""
  Bulk delete secrets (`DELETE /secrets_store/stores/:store_id/secrets`).
  """
  def delete_secrets(client, account_id, store_id, secrets)
      when is_list(secrets) or is_map(secrets) do
    c(client)
    |> Tesla.delete(secrets_path(account_id, store_id), body: normalize_payload(secrets))
    |> handle_response()
  end

  @doc ~S"""
  Get an individual secret (`GET /secrets/:secret_id`).
  """
  def get_secret(client, account_id, store_id, secret_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(secret_path(account_id, store_id, secret_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Delete an individual secret (`DELETE /secrets/:secret_id`).
  """
  def delete_secret(client, account_id, store_id, secret_id) do
    c(client)
    |> Tesla.delete(secret_path(account_id, store_id, secret_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Update an individual secret (`PATCH /secrets/:secret_id`).
  """
  def update_secret(client, account_id, store_id, secret_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(secret_path(account_id, store_id, secret_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Duplicate a secret (`POST /secrets/:secret_id/duplicate`).
  """
  def duplicate_secret(client, account_id, store_id, secret_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(duplicate_path(account_id, store_id, secret_id), params)
    |> handle_response()
  end

  defp normalize_payload(payload) when is_list(payload), do: payload
  defp normalize_payload(payload) when is_map(payload), do: [payload]

  defp base_path(account_id), do: "/accounts/#{account_id}/secrets_store"
  defp quota_path(account_id), do: base_path(account_id) <> "/quota"
  defp stores_path(account_id), do: base_path(account_id) <> "/stores"

  defp store_path(account_id, store_id) do
    stores_path(account_id) <> "/#{encode(store_id)}"
  end

  defp secrets_path(account_id, store_id) do
    store_path(account_id, store_id) <> "/secrets"
  end

  defp secret_path(account_id, store_id, secret_id) do
    secrets_path(account_id, store_id) <> "/#{encode(secret_id)}"
  end

  defp duplicate_path(account_id, store_id, secret_id) do
    secret_path(account_id, store_id, secret_id) <> "/duplicate"
  end

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

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
