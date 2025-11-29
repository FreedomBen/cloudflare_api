defmodule CloudflareApi.BinDb do
  @moduledoc ~S"""
  Upload binaries to or fetch binaries from the Cloudforce One BinDB service.
  """

  alias Tesla.Multipart

  def upload(client, account_id, file) do
    c(client)
    |> Tesla.post(base_path(account_id), file_to_multipart(file))
    |> handle_response()
  end

  def get(client, account_id, hash) do
    c(client)
    |> Tesla.get(binary_path(account_id, hash))
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/cloudforce-one/binary"
  defp binary_path(account_id, hash), do: base_path(account_id) <> "/#{hash}"

  defp file_to_multipart(%{body: body, filename: filename} = file)
       when is_binary(filename) do
    headers = [{"content-type", Map.get(file, :content_type, "application/octet-stream")}]

    Multipart.new()
    |> Multipart.add_file_content(body, filename, name: "file", headers: headers)
  end

  defp file_to_multipart(_),
    do:
      raise(ArgumentError, "file must be a map containing :body (iodata) and :filename (binary)")

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
