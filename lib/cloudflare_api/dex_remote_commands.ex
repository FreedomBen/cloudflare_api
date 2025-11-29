defmodule CloudflareApi.DexRemoteCommands do
  @moduledoc ~S"""
  Access the DEX Remote Commands endpoints under `/accounts/:account_id/dex/commands`.

  Functions return Cloudflare's JSON envelopes as `{:ok, result}` or
  `{:error, errors}` without any caching behaviour.
  """

  @doc ~S"""
  List remote commands for an account (`GET /accounts/:account_id/dex/commands`).

  Supports the following filters in `opts` (all forwarded verbatim):

    * `:page`, `:per_page`
    * `:from`, `:to`
    * `:device_id`, `:user_email`, `:command_type`, `:status`

  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(commands_path(account_id) <> query_suffix(opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a remote command (`POST /accounts/:account_id/dex/commands`).

  `params` must be a map that matches the OpenAPI schema for the command body.
  """
  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(commands_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  List devices that are eligible for remote captures
  (`GET /accounts/:account_id/dex/commands/devices`).

  Accepts pagination/search options in `opts`.
  """
  def eligible_devices(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(commands_path(account_id) <> "/devices" <> query_suffix(opts))
    |> handle_response()
  end

  @doc ~S"""
  Get the commands quota information for an account
  (`GET /accounts/:account_id/dex/commands/quota`).
  """
  def quota(client, account_id) do
    c(client)
    |> Tesla.get(commands_path(account_id) <> "/quota")
    |> handle_response()
  end

  @doc ~S"""
  Download the ZIP archive produced by a command execution
  (`GET /accounts/:account_id/dex/commands/:command_id/downloads/:filename`).

  Returns the raw binary body in the `{:ok, body}` tuple on success.
  """
  def download_output(client, account_id, command_id, filename) do
    c(client)
    |> Tesla.get(
      commands_path(account_id) <> "/#{command_id}/downloads/#{filename}"
    )
    |> handle_response()
  end

  defp commands_path(account_id), do: "/accounts/#{account_id}/dex/commands"

  defp query_suffix([]), do: ""
  defp query_suffix(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

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
