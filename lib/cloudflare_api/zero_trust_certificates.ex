defmodule CloudflareApi.ZeroTrustCertificates do
  @moduledoc ~S"""
  Manage Zero Trust Gateway certificates (`/accounts/:account_id/gateway/certificates`).
  """

  use CloudflareApi.Typespecs

  @doc """
  List certificates (`GET /accounts/:account_id/gateway/certificates`).
  """
  def list(client, account_id) do
    c(client)
    |> Tesla.get(base_path(account_id))
    |> handle_response()
  end

  @doc """
  Create a certificate (`POST /accounts/:account_id/gateway/certificates`).
  """
  def create(client, account_id, params \\ %{}) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc """
  Delete a certificate (`DELETE .../certificates/:certificate_id`).
  """
  def delete(client, account_id, certificate_id, params \\ %{}) do
    c(client)
    |> Tesla.delete(certificate_path(account_id, certificate_id), body: params)
    |> handle_response()
  end

  @doc """
  Get certificate details (`GET .../certificates/:certificate_id`).
  """
  def get(client, account_id, certificate_id) do
    c(client)
    |> Tesla.get(certificate_path(account_id, certificate_id))
    |> handle_response()
  end

  @doc """
  Activate a certificate (`POST .../certificates/:certificate_id/activate`).
  """
  def activate(client, account_id, certificate_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(activate_path(account_id, certificate_id), params)
    |> handle_response()
  end

  @doc """
  Deactivate a certificate (`POST .../certificates/:certificate_id/deactivate`).
  """
  def deactivate(client, account_id, certificate_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(deactivate_path(account_id, certificate_id), params)
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/gateway/certificates"

  defp certificate_path(account_id, certificate_id),
    do: base_path(account_id) <> "/#{encode(certificate_id)}"

  defp activate_path(account_id, certificate_id),
    do: certificate_path(account_id, certificate_id) <> "/activate"

  defp deactivate_path(account_id, certificate_id),
    do: certificate_path(account_id, certificate_id) <> "/deactivate"

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
