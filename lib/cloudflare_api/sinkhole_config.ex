defmodule CloudflareApi.SinkholeConfig do
  @moduledoc ~S"""
  List account sinkhole configurations via `/accounts/:account_id/intel/sinkholes`.
  """

  @doc ~S"""
  List sinkholes owned by an account (`GET /intel/sinkholes`).
  """
  def list(client, account_id) do
    c(client)
    |> Tesla.get("/accounts/#{account_id}/intel/sinkholes")
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
