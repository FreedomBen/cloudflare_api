defmodule CloudflareApi.WorkersAiFinetune do
  @moduledoc ~S"""
  Workers AI finetune helpers for listing, creating, and uploading finetune assets.
  """

  @doc ~S"""
  List finetunes for an account (`GET /accounts/:account_id/ai/finetunes`).
  """
  def list_finetunes(client, account_id) do
    c(client)
    |> Tesla.get(base_path(account_id))
    |> handle_response()
  end

  @doc ~S"""
  Create a finetune job (`POST /accounts/:account_id/ai/finetunes`).
  """
  def create_finetune(client, account_id, params \\ %{}) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  List public finetunes (`GET /accounts/:account_id/ai/finetunes/public`).

  Supports `:limit`, `:offset`, and `:orderBy` options.
  """
  def list_public_finetunes(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query("#{base_path(account_id)}/public", opts))
    |> handle_response()
  end

  @doc ~S"""
  Upload a finetune asset (`POST /accounts/:account_id/ai/finetunes/:id/finetune-assets`).

  Pass a `Tesla.Multipart` struct or IO data representing the multipart body.
  """
  def upload_finetune_asset(client, account_id, finetune_id, body) do
    c(client)
    |> Tesla.post(asset_path(account_id, finetune_id), body)
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/ai/finetunes"

  defp asset_path(account_id, finetune_id),
    do: base_path(account_id) <> "/#{encode(finetune_id)}/finetune-assets"

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

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
