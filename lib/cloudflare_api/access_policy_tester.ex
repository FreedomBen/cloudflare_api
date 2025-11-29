defmodule CloudflareApi.AccessPolicyTester do
  @moduledoc ~S"""
  Run and inspect Access policy tests for an account.
  """

  def create_test(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(tests_path(account_id), params)
    |> handle_response()
  end

  def get_test(client, account_id, test_id) do
    c(client)
    |> Tesla.get(test_path(account_id, test_id))
    |> handle_response()
  end

  def list_test_users(client, account_id, test_id, opts \\ []) do
    c(client)
    |> Tesla.get(users_url(account_id, test_id, opts))
    |> handle_response()
  end

  defp tests_path(account_id), do: "/accounts/#{account_id}/access/policy-tests"
  defp test_path(account_id, test_id), do: tests_path(account_id) <> "/#{test_id}"

  defp users_url(account_id, test_id, []), do: test_path(account_id, test_id) <> "/users"

  defp users_url(account_id, test_id, opts) do
    users_url(account_id, test_id, []) <> "?" <> CloudflareApi.uri_encode_opts(opts)
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
