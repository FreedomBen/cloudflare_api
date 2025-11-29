defmodule CloudflareApi.InfrastructureAccessTargets do
  @moduledoc ~S"""
  Manage Access targets under `/accounts/:account_id/infrastructure/targets`.
  """

  def list(client, account_id, opts \\ []) do
    request(client, :get, base_path(account_id) <> query_suffix(opts))
  end

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base_path(account_id), params)
  end

  def get(client, account_id, target_id) do
    request(client, :get, target_path(account_id, target_id))
  end

  def update(client, account_id, target_id, params) when is_map(params) do
    request(client, :put, target_path(account_id, target_id), params)
  end

  def delete(client, account_id, target_id) do
    request(client, :delete, target_path(account_id, target_id), %{})
  end

  def create_targets(client, account_id, targets) when is_list(targets) do
    request(client, :put, base_path(account_id) <> "/batch", targets)
  end

  def delete_targets(client, account_id, target_ids) when is_list(target_ids) do
    request(client, :post, base_path(account_id) <> "/batch_delete", %{"target_ids" => target_ids})
  end

  def delete_targets_deprecated(client, account_id, targets) when is_list(targets) do
    request(client, :delete, base_path(account_id) <> "/batch", targets)
  end

  def get_status(client, account_id, target_id) do
    request(client, :get, target_path(account_id, target_id) <> "/status")
  end

  def get_loa(client, account_id, target_id) do
    c(client)
    |> Tesla.get(target_path(account_id, target_id) <> "/loa")
    |> handle_binary_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/infrastructure/targets"
  defp target_path(account_id, target_id), do: base_path(account_id) <> "/#{target_id}"

  defp query_suffix([]), do: ""
  defp query_suffix(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} ->
          Tesla.get(client, url)

        {:post, params} ->
          Tesla.post(client, url, params)

        {:put, params} ->
          Tesla.put(client, url, params)

        {:delete, params} ->
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

  defp handle_binary_response({:ok, %Tesla.Env{status: status, body: body}})
       when status in 200..299,
       do: {:ok, body}

  defp handle_binary_response({:ok, %Tesla.Env{body: %{"errors" => errors}}}),
    do: {:error, errors}

  defp handle_binary_response(other), do: {:error, other}

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
