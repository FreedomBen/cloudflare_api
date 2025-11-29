defmodule CloudflareApi.MagicNetworkMonitoringVpcFlows do
  @moduledoc ~S"""
  Generate authentication tokens for Magic Network Monitoring VPC flow log export.
  """

  def generate_token(client, account_id) do
    c(client)
    |> Tesla.post("/accounts/#{account_id}/mnm/vpc-flows/token", %{})
    |> handle_response()
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
