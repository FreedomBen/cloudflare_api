defmodule CloudflareApi.GitHubIntegration do
  @moduledoc ~S"""
  Helpers for the GitHub integration endpoints under
  `/accounts/:account_id/builds/repos/:provider_type/:provider_account_id/:repo_id`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Retrieve the repository configuration autofill
  (`GET /accounts/:account_id/builds/repos/:provider_type/:provider_account_id/:repo_id/config_autofill`).
  """
  def config_autofill(client, account_id, provider_type, provider_account_id, repo_id) do
    request(
      client,
      :get,
      "/accounts/#{account_id}/builds/repos/#{provider_type}/#{provider_account_id}/#{repo_id}/config_autofill"
    )
  end

  defp request(client, method, url) do
    client = c(client)

    result =
      case method do
        :get -> Tesla.get(client, url)
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

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
