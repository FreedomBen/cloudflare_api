defmodule CloudflareApi.Web3Hostname do
  @moduledoc ~S"""
  Helper functions for Cloudflare Web3 Hostname endpoints, including IPFS
  content list management.
  """

  @doc ~S"""
  List Web3 hostnames (`GET /zones/:zone_id/web3/hostnames`).
  """
  def list_hostnames(client, zone_id) do
    c(client)
    |> Tesla.get(hostnames_path(zone_id))
    |> handle_response()
  end

  @doc ~S"""
  Create a Web3 hostname (`POST /zones/:zone_id/web3/hostnames`).
  """
  def create_hostname(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(hostnames_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a Web3 hostname (`DELETE /zones/:zone_id/web3/hostnames/:identifier`).
  """
  def delete_hostname(client, zone_id, identifier) do
    c(client)
    |> Tesla.delete(hostname_path(zone_id, identifier), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Fetch a Web3 hostname (`GET /zones/:zone_id/web3/hostnames/:identifier`).
  """
  def get_hostname(client, zone_id, identifier) do
    c(client)
    |> Tesla.get(hostname_path(zone_id, identifier))
    |> handle_response()
  end

  @doc ~S"""
  Patch a Web3 hostname (`PATCH /zones/:zone_id/web3/hostnames/:identifier`).
  """
  def patch_hostname(client, zone_id, identifier, params) when is_map(params) do
    c(client)
    |> Tesla.patch(hostname_path(zone_id, identifier), params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch the IPFS universal path content list (`GET /zones/:zone_id/web3/hostnames/:identifier/ipfs_universal_path/content_list`).
  """
  def get_content_list(client, zone_id, identifier) do
    c(client)
    |> Tesla.get(content_list_path(zone_id, identifier))
    |> handle_response()
  end

  @doc ~S"""
  Replace the IPFS universal path content list (`PUT /zones/:zone_id/web3/hostnames/:identifier/ipfs_universal_path/content_list`).
  """
  def update_content_list(client, zone_id, identifier, params) when is_map(params) do
    c(client)
    |> Tesla.put(content_list_path(zone_id, identifier), params)
    |> handle_response()
  end

  @doc ~S"""
  List content list entries (`GET /zones/:zone_id/web3/hostnames/:identifier/ipfs_universal_path/content_list/entries`).
  """
  def list_content_list_entries(client, zone_id, identifier) do
    c(client)
    |> Tesla.get(entries_path(zone_id, identifier))
    |> handle_response()
  end

  @doc ~S"""
  Create a content list entry (`POST /zones/:zone_id/web3/hostnames/:identifier/ipfs_universal_path/content_list/entries`).
  """
  def create_content_list_entry(client, zone_id, identifier, params) when is_map(params) do
    c(client)
    |> Tesla.post(entries_path(zone_id, identifier), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a content list entry (`DELETE /zones/:zone_id/web3/hostnames/:identifier/ipfs_universal_path/content_list/entries/:content_list_entry_identifier`).
  """
  def delete_content_list_entry(client, zone_id, identifier, entry_id) do
    c(client)
    |> Tesla.delete(entry_path(zone_id, identifier, entry_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Fetch a content list entry (`GET /zones/:zone_id/web3/hostnames/:identifier/ipfs_universal_path/content_list/entries/:content_list_entry_identifier`).
  """
  def get_content_list_entry(client, zone_id, identifier, entry_id) do
    c(client)
    |> Tesla.get(entry_path(zone_id, identifier, entry_id))
    |> handle_response()
  end

  @doc ~S"""
  Replace a content list entry (`PUT /zones/:zone_id/web3/hostnames/:identifier/ipfs_universal_path/content_list/entries/:content_list_entry_identifier`).
  """
  def update_content_list_entry(client, zone_id, identifier, entry_id, params)
      when is_map(params) do
    c(client)
    |> Tesla.put(entry_path(zone_id, identifier, entry_id), params)
    |> handle_response()
  end

  defp hostnames_path(zone_id), do: "/zones/#{zone_id}/web3/hostnames"
  defp hostname_path(zone_id, identifier), do: hostnames_path(zone_id) <> "/#{identifier}"

  defp content_list_path(zone_id, identifier),
    do: hostname_path(zone_id, identifier) <> "/ipfs_universal_path/content_list"

  defp entries_path(zone_id, identifier), do: content_list_path(zone_id, identifier) <> "/entries"

  defp entry_path(zone_id, identifier, entry_id),
    do: entries_path(zone_id, identifier) <> "/#{entry_id}"

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
