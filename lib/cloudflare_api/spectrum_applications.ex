defmodule CloudflareApi.SpectrumApplications do
  @moduledoc ~S"""
  Manage Spectrum applications under `/zones/:zone_id/spectrum/apps`.
  """

  @doc ~S"""
  List Spectrum applications (`GET /spectrum/apps`).
  """
  def list(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base(zone_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a Spectrum application (`POST /spectrum/apps`).
  """
  def create(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch a Spectrum application (`GET /spectrum/apps/:app_id`).
  """
  def get(client, zone_id, app_id) do
    c(client)
    |> Tesla.get(app_path(zone_id, app_id))
    |> handle_response()
  end

  @doc ~S"""
  Update a Spectrum application (`PUT /spectrum/apps/:app_id`).
  """
  def update(client, zone_id, app_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(app_path(zone_id, app_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a Spectrum application (`DELETE /spectrum/apps/:app_id`).
  """
  def delete(client, zone_id, app_id) do
    c(client)
    |> Tesla.delete(app_path(zone_id, app_id), body: %{})
    |> handle_response()
  end

  defp base(zone_id), do: "/zones/#{zone_id}/spectrum/apps"

  defp app_path(zone_id, app_id) do
    base(zone_id) <> "/#{encode(app_id)}"
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
