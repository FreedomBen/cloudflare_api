defmodule CloudflareApi.Presets do
  @moduledoc ~S"""
  Manage Realtime Kit presets (`/accounts/:account_id/realtime/kit/:app_id/presets`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List presets for an app (`GET /presets`).
  """
  def list(client, account_id, app_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(account_id, app_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a preset (`POST /presets`).
  """
  def create(client, account_id, app_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id, app_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Retrieve a preset (`GET /presets/:preset_id`).
  """
  def get(client, account_id, app_id, preset_id) do
    c(client)
    |> Tesla.get(preset_path(account_id, app_id, preset_id))
    |> handle_response()
  end

  @doc ~S"""
  Update a preset (`PATCH /presets/:preset_id`).
  """
  def update(client, account_id, app_id, preset_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(preset_path(account_id, app_id, preset_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a preset (`DELETE /presets/:preset_id`).
  """
  def delete(client, account_id, app_id, preset_id) do
    c(client)
    |> Tesla.delete(preset_path(account_id, app_id, preset_id), body: %{})
    |> handle_response()
  end

  defp base_path(account_id, app_id),
    do: "/accounts/#{account_id}/realtime/kit/#{app_id}/presets"

  defp preset_path(account_id, app_id, preset_id),
    do: base_path(account_id, app_id) <> "/#{encode(preset_id)}"

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
