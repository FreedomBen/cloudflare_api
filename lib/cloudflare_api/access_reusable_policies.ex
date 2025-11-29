defmodule CloudflareApi.AccessReusablePolicies do
  @moduledoc ~S"""
  Manage reusable Access policies at the account level.
  """

  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(account_id, opts))
    |> handle_response()
  end

  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  def get(client, account_id, policy_id) do
    c(client)
    |> Tesla.get(policy_path(account_id, policy_id))
    |> handle_response()
  end

  def update(client, account_id, policy_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(policy_path(account_id, policy_id), params)
    |> handle_response()
  end

  def delete(client, account_id, policy_id) do
    c(client)
    |> Tesla.delete(policy_path(account_id, policy_id), body: %{})
    |> handle_response()
  end

  defp list_url(account_id, []), do: base_path(account_id)

  defp list_url(account_id, opts) do
    base_path(account_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/access/policies"
  defp policy_path(account_id, policy_id), do: base_path(account_id) <> "/#{policy_id}"

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
