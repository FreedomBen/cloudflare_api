defmodule CloudflareApi.CloudflareIps do
  @moduledoc ~S"""
  Fetch the list of Cloudflare IP ranges.
  """

  def list(client, opts \\ []) do
    c(client)
    |> Tesla.get("/ips" <> query_suffix(opts))
    |> handle_response()
  end

  defp query_suffix([]), do: ""
  defp query_suffix(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

  defp handle_response({:ok, %Tesla.Env{status: status, body: body}}) when status in 200..299,
    do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{body: %{"errors" => errors}}}), do: {:error, errors}
  defp handle_response(other), do: {:error, other}

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
