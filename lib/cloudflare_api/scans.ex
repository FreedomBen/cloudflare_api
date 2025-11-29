defmodule CloudflareApi.Scans do
  @moduledoc ~S"""
  Cloudforce One scan configuration APIs under `/accounts/:account_id/cloudforce-one/scans`.
  """

  def get_config(client, account_id, opts \\ []) do
    fetch(client, "/accounts/#{account_id}/cloudforce-one/scans/config", opts)
  end

  def create_config(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post("/accounts/#{account_id}/cloudforce-one/scans/config", params)
    |> handle_response()
  end

  def update_config(client, account_id, config_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(config_path(account_id, config_id), params)
    |> handle_response()
  end

  def delete_config(client, account_id, config_id) do
    c(client)
    |> Tesla.delete(config_path(account_id, config_id), body: %{})
    |> handle_response()
  end

  def open_ports(client, account_id, config_id, opts \\ []) do
    fetch(client, "/accounts/#{account_id}/cloudforce-one/scans/results/#{encode(config_id)}", opts)
  end

  defp config_path(account_id, config_id), do: "/accounts/#{account_id}/cloudforce-one/scans/config/#{encode(config_id)}"

  defp fetch(client_or_fun, path, opts) do
    c(client_or_fun)
    |> Tesla.get(with_query(path, opts))
    |> handle_response()
  end

  defp with_query(path, []), do: path
  defp with_query(path, opts), do: path <> "?" <> CloudflareApi.uri_encode_opts(opts)

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

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
