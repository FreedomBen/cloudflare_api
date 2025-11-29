defmodule CloudflareApi.BotnetThreatFeed do
  @moduledoc ~S"""
  Work with Botnet Threat Feed reports and ASN configurations.
  """

  @doc ~S"""
  List asn configs for botnet threat feed.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.BotnetThreatFeed.list_asn_configs(client, "account_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list_asn_configs(client, account_id) do
    c(client)
    |> Tesla.get(configs_path(account_id))
    |> handle_response()
  end

  @doc ~S"""
  Delete asn config for botnet threat feed.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.BotnetThreatFeed.delete_asn_config(client, "account_id", "asn_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_asn_config(client, account_id, asn_id) do
    c(client)
    |> Tesla.delete(config_path(account_id, asn_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Day report for botnet threat feed.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.BotnetThreatFeed.day_report(client, "account_id", "asn_id", [])
      {:ok, %{"id" => "example"}}

  """

  def day_report(client, account_id, asn_id, opts \\ []) do
    c(client)
    |> Tesla.get(day_report_url(account_id, asn_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Full report for botnet threat feed.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.BotnetThreatFeed.full_report(client, "account_id", "asn_id")
      {:ok, %{"id" => "example"}}

  """

  def full_report(client, account_id, asn_id) do
    c(client)
    |> Tesla.get(full_report_path(account_id, asn_id))
    |> handle_response()
  end

  defp configs_path(account_id), do: "/accounts/#{account_id}/botnet_feed/configs/asn"
  defp config_path(account_id, asn_id), do: configs_path(account_id) <> "/#{asn_id}"
  defp full_report_path(account_id, asn_id), do: asn_prefix(account_id, asn_id) <> "/full_report"

  defp day_report_url(account_id, asn_id, []), do: asn_prefix(account_id, asn_id) <> "/day_report"

  defp day_report_url(account_id, asn_id, opts) do
    day_report_url(account_id, asn_id, []) <> "?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp asn_prefix(account_id, asn_id),
    do: "/accounts/#{account_id}/botnet_feed/asn/#{asn_id}"

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
