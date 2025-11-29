defmodule CloudflareApi.TargetIndustry do
  @moduledoc ~S"""
  Access Cloudforce One target industry metadata via `/accounts/:account_id/cloudforce-one/events`.
  """

  @doc ~S"""
  List target industries (`GET /events/targetIndustries`).
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base(account_id) <> "/targetIndustries", opts))
    |> handle_response()
  end

  @doc ~S"""
  List the complete target industry catalog (`GET /events/targetIndustries/catalog`).
  """
  def list_catalog(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base(account_id) <> "/targetIndustries/catalog", opts))
    |> handle_response()
  end

  @doc ~S"""
  List target industries for a dataset (`GET /events/dataset/:dataset_id/targetIndustries`).
  """
  def list_for_dataset(client, account_id, dataset_id, opts \\ []) do
    c(client)
    |> Tesla.get(
      with_query(
        "/accounts/#{account_id}/cloudforce-one/events/dataset/#{encode(dataset_id)}/targetIndustries",
        opts
      )
    )
    |> handle_response()
  end

  defp base(account_id), do: "/accounts/#{account_id}/cloudforce-one/events"
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
