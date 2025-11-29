defmodule CloudflareApi.Builds do
  @moduledoc ~S"""
  Inspect and manage Cloudflare Builds under an account.
  """

  def list_by_version_ids(client, account_id, version_ids) do
    query = [version_ids: list_to_param(version_ids)]

    c(client)
    |> Tesla.get(builds_url(account_id, query))
    |> handle_response()
  end

  def latest_by_scripts(client, account_id, external_script_ids) do
    query = [external_script_ids: list_to_param(external_script_ids)]

    c(client)
    |> Tesla.get(latest_url(account_id, query))
    |> handle_response()
  end

  def get(client, account_id, build_uuid) do
    c(client)
    |> Tesla.get(build_path(account_id, build_uuid))
    |> handle_response()
  end

  def cancel(client, account_id, build_uuid) do
    c(client)
    |> Tesla.put(build_path(account_id, build_uuid) <> "/cancel", %{})
    |> handle_response()
  end

  def logs(client, account_id, build_uuid, opts \\ []) do
    c(client)
    |> Tesla.get(build_path(account_id, build_uuid) <> "/logs" <> query_suffix(opts))
    |> handle_response()
  end

  defp builds_url(account_id, query),
    do: base_path(account_id) <> "?" <> CloudflareApi.uri_encode_opts(query)

  defp latest_url(account_id, query),
    do: base_path(account_id) <> "/latest?" <> CloudflareApi.uri_encode_opts(query)

  defp base_path(account_id), do: "/accounts/#{account_id}/builds/builds"
  defp build_path(account_id, build_uuid), do: base_path(account_id) <> "/#{build_uuid}"

  defp query_suffix([]), do: ""
  defp query_suffix(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

  defp list_to_param(list) when is_list(list), do: Enum.join(list, ",")
  defp list_to_param(value) when is_binary(value), do: value

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
