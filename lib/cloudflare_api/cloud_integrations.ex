defmodule CloudflareApi.CloudIntegrations do
  @moduledoc ~S"""
  Manage Magic Cloud provider integrations for an account.
  """

  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(account_id, opts))
    |> handle_response()
  end

  def create(client, account_id, params, headers \\ []) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params, headers: headers)
    |> handle_response()
  end

  def discover_all(client, account_id) do
    c(client)
    |> Tesla.post(base_path(account_id) <> "/discover", %{})
    |> handle_response()
  end

  def get(client, account_id, provider_id, opts \\ []) do
    c(client)
    |> Tesla.get(provider_path(account_id, provider_id) <> query_suffix(opts))
    |> handle_response()
  end

  def update(client, account_id, provider_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(provider_path(account_id, provider_id), params)
    |> handle_response()
  end

  def patch(client, account_id, provider_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(provider_path(account_id, provider_id), params)
    |> handle_response()
  end

  def delete(client, account_id, provider_id) do
    c(client)
    |> Tesla.delete(provider_path(account_id, provider_id), body: %{})
    |> handle_response()
  end

  def discover(client, account_id, provider_id, opts \\ []) do
    c(client)
    |> Tesla.post(provider_path(account_id, provider_id) <> "/discover" <> query_suffix(opts), %{})
    |> handle_response()
  end

  def initial_setup(client, account_id, provider_id) do
    c(client)
    |> Tesla.get(provider_path(account_id, provider_id) <> "/initial_setup")
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/magic/cloud/providers"
  defp provider_path(account_id, provider_id), do: base_path(account_id) <> "/#{provider_id}"

  defp list_url(account_id, []), do: base_path(account_id)

  defp list_url(account_id, opts),
    do: base_path(account_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)

  defp query_suffix([]), do: ""
  defp query_suffix(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

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
