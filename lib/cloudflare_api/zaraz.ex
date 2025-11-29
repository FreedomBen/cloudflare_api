defmodule CloudflareApi.Zaraz do
  @moduledoc ~S"""
  Manage Zaraz zone settings (`/zones/:zone_id/settings/zaraz/*`).
  """

  @doc """
  Fetch the Zaraz configuration (`GET /zones/:zone_id/settings/zaraz/config`).
  """
  def get_config(client, zone_id) do
    c(client)
    |> Tesla.get(config_path(zone_id))
    |> handle_response()
  end

  @doc """
  Update the Zaraz configuration (`PUT /zones/:zone_id/settings/zaraz/config`).
  """
  def put_config(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(config_path(zone_id), params)
    |> handle_response()
  end

  @doc """
  Fetch default settings (`GET /zones/:zone_id/settings/zaraz/default`).
  """
  def get_default(client, zone_id) do
    c(client)
    |> Tesla.get(default_path(zone_id))
    |> handle_response()
  end

  @doc """
  Export Zaraz configuration (`GET /zones/:zone_id/settings/zaraz/export`).
  """
  def export(client, zone_id) do
    c(client)
    |> Tesla.get(export_path(zone_id))
    |> handle_response()
  end

  @doc """
  Fetch change history (`GET /zones/:zone_id/settings/zaraz/history`).
  """
  def get_history(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(history_path(zone_id), opts))
    |> handle_response()
  end

  @doc """
  Update history settings (`PUT /zones/:zone_id/settings/zaraz/history`).
  """
  def put_history(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(history_path(zone_id), params)
    |> handle_response()
  end

  @doc """
  Fetch history configs (`GET /zones/:zone_id/settings/zaraz/history/configs`).
  """
  def get_history_configs(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(history_configs_path(zone_id), opts))
    |> handle_response()
  end

  @doc """
  Publish the latest Zaraz workflow (`POST /zones/:zone_id/settings/zaraz/publish`).
  """
  def publish(client, zone_id, params \\ %{}) do
    c(client)
    |> Tesla.post(publish_path(zone_id), params)
    |> handle_response()
  end

  @doc """
  Fetch the workflow definition (`GET /zones/:zone_id/settings/zaraz/workflow`).
  """
  def get_workflow(client, zone_id) do
    c(client)
    |> Tesla.get(workflow_path(zone_id))
    |> handle_response()
  end

  @doc """
  Update the workflow definition (`PUT /zones/:zone_id/settings/zaraz/workflow`).
  """
  def put_workflow(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(workflow_path(zone_id), params)
    |> handle_response()
  end

  defp config_path(zone_id), do: "/zones/#{zone_id}/settings/zaraz/config"
  defp default_path(zone_id), do: "/zones/#{zone_id}/settings/zaraz/default"
  defp export_path(zone_id), do: "/zones/#{zone_id}/settings/zaraz/export"
  defp history_path(zone_id), do: "/zones/#{zone_id}/settings/zaraz/history"
  defp history_configs_path(zone_id), do: history_path(zone_id) <> "/configs"
  defp publish_path(zone_id), do: "/zones/#{zone_id}/settings/zaraz/publish"
  defp workflow_path(zone_id), do: "/zones/#{zone_id}/settings/zaraz/workflow"

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
