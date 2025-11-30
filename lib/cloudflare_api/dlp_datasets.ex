defmodule CloudflareApi.DlpDatasets do
  @moduledoc ~S"""
  Manage DLP datasets under `/accounts/:account_id/dlp/datasets`.

  These helpers stay close to the HTTP surface and return Cloudflare's
  envelopes as `{:ok, result}` / `{:error, errors}` tuples.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List datasets for an account (`GET /accounts/:account_id/dlp/datasets`).
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(base_path(account_id) <> query_suffix(opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a dataset (`POST /accounts/:account_id/dlp/datasets`).
  """
  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch a dataset (`GET /accounts/:account_id/dlp/datasets/:dataset_id`).
  """
  def get(client, account_id, dataset_id) do
    c(client)
    |> Tesla.get(dataset_path(account_id, dataset_id))
    |> handle_response()
  end

  @doc ~S"""
  Update dataset metadata (`PUT /accounts/:account_id/dlp/datasets/:dataset_id`).
  """
  def update(client, account_id, dataset_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(dataset_path(account_id, dataset_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a dataset (`DELETE /accounts/:account_id/dlp/datasets/:dataset_id`).
  """
  def delete(client, account_id, dataset_id) do
    c(client)
    |> Tesla.delete(dataset_path(account_id, dataset_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Prepare to upload a new dataset version
  (`POST /accounts/:account_id/dlp/datasets/:dataset_id/upload`).
  """
  def create_version(client, account_id, dataset_id) do
    c(client)
    |> Tesla.post(dataset_path(account_id, dataset_id) <> "/upload", %{})
    |> handle_response()
  end

  @doc ~S"""
  Upload raw bytes for a dataset version
  (`POST /accounts/:account_id/dlp/datasets/:dataset_id/upload/:version`).
  """
  @spec upload_version(
          CloudflareApi.client(),
          String.t(),
          String.t(),
          String.t(),
          iodata()
        ) :: CloudflareApi.result(term())
  def upload_version(client, account_id, dataset_id, version, data)
      when is_binary(data) or is_list(data) do
    c(client)
    |> Tesla.post(
      dataset_path(account_id, dataset_id) <> "/upload/#{version}",
      data,
      headers: [{"content-type", "application/octet-stream"}]
    )
    |> handle_response()
  end

  @doc ~S"""
  Define columns for a multi-column upload
  (`POST /accounts/:account_id/dlp/datasets/:dataset_id/versions/:version`).
  """
  def define_columns(client, account_id, dataset_id, version, params) when is_map(params) do
    c(client)
    |> Tesla.post(
      dataset_path(account_id, dataset_id) <> "/versions/#{version}",
      params
    )
    |> handle_response()
  end

  @doc ~S"""
  Upload an entry for a multi-column dataset
  (`POST /accounts/:account_id/dlp/datasets/:dataset_id/versions/:version/entries/:entry_id`).
  """
  @spec upload_dataset_column(
          CloudflareApi.client(),
          String.t(),
          String.t(),
          String.t(),
          String.t(),
          iodata()
        ) :: CloudflareApi.result(term())
  def upload_dataset_column(client, account_id, dataset_id, version, entry_id, data)
      when is_binary(data) or is_list(data) do
    c(client)
    |> Tesla.post(
      dataset_path(account_id, dataset_id) <> "/versions/#{version}/entries/#{entry_id}",
      data,
      headers: [{"content-type", "application/octet-stream"}]
    )
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/dlp/datasets"
  defp dataset_path(account_id, dataset_id), do: base_path(account_id) <> "/#{dataset_id}"

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
