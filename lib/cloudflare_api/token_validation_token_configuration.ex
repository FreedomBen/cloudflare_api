defmodule CloudflareApi.TokenValidationTokenConfiguration do
  @moduledoc ~S"""
  Manage Token Validation configurations under `/zones/:zone_id/token_validation/config`.
  """

  def list(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base(zone_id), opts))
    |> handle_response()
  end

  def create(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(zone_id), params)
    |> handle_response()
  end

  def get(client, zone_id, config_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(config_path(zone_id, config_id), opts))
    |> handle_response()
  end

  def update(client, zone_id, config_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(config_path(zone_id, config_id), params)
    |> handle_response()
  end

  def delete(client, zone_id, config_id) do
    c(client)
    |> Tesla.delete(config_path(zone_id, config_id), body: %{})
    |> handle_response()
  end

  def update_credentials(client, zone_id, config_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(config_path(zone_id, config_id) <> "/credentials", params)
    |> handle_response()
  end

  defp base(zone_id), do: "/zones/#{zone_id}/token_validation/config"

  defp config_path(zone_id, config_id) do
    base(zone_id) <> "/#{encode(config_id)}"
  end

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
