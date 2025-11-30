defmodule CloudflareApi.OriginCa do
  @moduledoc ~S"""
  Manage Origin CA certificates (`/certificates`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List Origin CA certificates (`GET /certificates`).
  """
  def list(client, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create an Origin CA certificate (`POST /certificates`).
  """
  def create(client, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(), params)
    |> handle_response()
  end

  @doc ~S"""
  Retrieve a certificate (`GET /certificates/:certificate_id`).
  """
  def get(client, certificate_id) do
    c(client)
    |> Tesla.get(cert_path(certificate_id))
    |> handle_response()
  end

  @doc ~S"""
  Revoke a certificate (`DELETE /certificates/:certificate_id`).
  """
  def revoke(client, certificate_id) do
    c(client)
    |> Tesla.delete(cert_path(certificate_id), body: %{})
    |> handle_response()
  end

  defp base_path, do: "/certificates"
  defp cert_path(id), do: base_path() <> "/#{encode(id)}"

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
