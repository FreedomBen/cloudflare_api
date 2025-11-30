defmodule CloudflareApi.SecurityTxt do
  @moduledoc ~S"""
  Manage `security.txt` data for a zone via `/zones/:zone_id/security-center/securitytxt`.

  These endpoints live under the Security Center portion of the Cloudflare API.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Fetch the current `security.txt` document (`GET /zones/:zone_id/security-center/securitytxt`).

  Returns the `result` map, which includes fields such as `contact`, `policy`,
  `acknowledgments`, and other standard `security.txt` directives.
  """
  def get(client, zone_id) do
    request(client, :get, path(zone_id))
  end

  @doc ~S"""
  Replace the `security.txt` document for a zone (`PUT /zones/:zone_id/security-center/securitytxt`).

  Pass a map compatible with the `security-center_securityTxt` schema — e.g.
  `%{"enabled" => true, "contact" => ["mailto:security@example.com"]}`.
  """
  def update(client, zone_id, params) when is_map(params) do
    request(client, :put, path(zone_id), params)
  end

  @doc ~S"""
  Delete the stored `security.txt` document (`DELETE /zones/:zone_id/security-center/securitytxt`).
  """
  def delete(client, zone_id) do
    request(client, :delete, path(zone_id))
  end

  defp path(zone_id), do: "/zones/#{zone_id}/security-center/securitytxt"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case method do
        :get -> Tesla.get(client, url)
        :put -> Tesla.put(client, url, body || %{})
        :delete -> delete(client, url, body)
      end

    handle_response(result)
  end

  defp delete(client, url, nil), do: Tesla.delete(client, url)
  defp delete(client, url, body), do: Tesla.delete(client, url, body: body)

  defp handle_response({:ok, %Tesla.Env{status: status, body: %{"result" => result}}})
       when status in 200..299,
       do: {:ok, result}

  defp handle_response({:ok, %Tesla.Env{status: status, body: body}})
       when status in 200..299 and is_map(body),
       do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{status: status, body: body}})
       when status in 200..299,
       do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{body: %{"errors" => errors}}}), do: {:error, errors}
  defp handle_response(other), do: {:error, other}

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
