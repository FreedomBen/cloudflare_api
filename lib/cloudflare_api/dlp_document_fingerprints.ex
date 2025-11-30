defmodule CloudflareApi.DlpDocumentFingerprints do
  @moduledoc ~S"""
  Manage DLP document fingerprints under
  `/accounts/:account_id/dlp/document_fingerprints`.
  """

  use CloudflareApi.Typespecs

  alias Tesla.Multipart

  @doc ~S"""
  List document fingerprints (`GET /accounts/:account_id/dlp/document_fingerprints`).
  """
  def list(client, account_id) do
    c(client)
    |> Tesla.get(base_path(account_id))
    |> handle_response()
  end

  @doc ~S"""
  Create a fingerprint (`POST /accounts/:account_id/dlp/document_fingerprints`).
  """
  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch a fingerprint (`GET /accounts/:account_id/dlp/document_fingerprints/:id`).
  """
  def get(client, account_id, fingerprint_id) do
    c(client)
    |> Tesla.get(fingerprint_path(account_id, fingerprint_id))
    |> handle_response()
  end

  @doc ~S"""
  Update fingerprint metadata (`POST /accounts/:account_id/dlp/document_fingerprints/:id`).
  """
  def update(client, account_id, fingerprint_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(fingerprint_path(account_id, fingerprint_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a fingerprint (`DELETE /accounts/:account_id/dlp/document_fingerprints/:id`).
  """
  def delete(client, account_id, fingerprint_id) do
    c(client)
    |> Tesla.delete(fingerprint_path(account_id, fingerprint_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Upload a new file version for a fingerprint
  (`PUT /accounts/:account_id/dlp/document_fingerprints/:id`).
  """
  def upload_file(client, account_id, fingerprint_id, %Multipart{} = multipart) do
    c(client)
    |> Tesla.put(fingerprint_path(account_id, fingerprint_id), multipart)
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/dlp/document_fingerprints"

  defp fingerprint_path(account_id, fingerprint_id) do
    base_path(account_id) <> "/#{fingerprint_id}"
  end

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
