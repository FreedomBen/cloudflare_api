defmodule CloudflareApi.WorkersAiImageClassification do
  @moduledoc ~S"""
  Workers AI image classification helpers.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Execute the Microsoft ResNet-50 classifier
  (`POST /accounts/:account_id/ai/run/@cf/microsoft/resnet-50`).
  """
  @spec run_cf_microsoft_resnet_50(
          CloudflareApi.client(),
          String.t(),
          iodata(),
          CloudflareApi.options()
        ) :: CloudflareApi.result(term())
  def run_cf_microsoft_resnet_50(client, account_id, body \\ <<>>, opts \\ []) do
    post_run(client, account_id, "@cf/microsoft/resnet-50", body, opts)
  end

  defp post_run(client, account_id, model, body, opts) do
    c(client)
    |> Tesla.post(with_query(run_path(account_id, model), opts), body)
    |> handle_response()
  end

  defp run_path(account_id, model), do: "/accounts/#{account_id}/ai/run/#{model}"

  defp with_query(url, []), do: url
  defp with_query(url, opts), do: url <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
