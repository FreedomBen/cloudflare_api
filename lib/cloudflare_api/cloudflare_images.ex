defmodule CloudflareApi.CloudflareImages do
  @moduledoc ~S"""
  Manage Cloudflare Images resources.
  """

  alias Tesla.Multipart

  def list_v1(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(v1_base(account_id) <> query_suffix(opts))
    |> handle_response()
  end

  def list_v2(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get("/accounts/#{account_id}/images/v2" <> query_suffix(opts))
    |> handle_response()
  end

  def upload(client, account_id, %Multipart{} = multipart) do
    c(client)
    |> Tesla.post(v1_base(account_id), multipart)
    |> handle_response()
  end

  def stats(client, account_id) do
    c(client)
    |> Tesla.get(v1_base(account_id) <> "/stats")
    |> handle_response()
  end

  def get(client, account_id, image_id) do
    c(client)
    |> Tesla.get(image_path(account_id, image_id))
    |> handle_response()
  end

  def update(client, account_id, image_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(image_path(account_id, image_id), params)
    |> handle_response()
  end

  def delete(client, account_id, image_id) do
    c(client)
    |> Tesla.delete(image_path(account_id, image_id), body: %{})
    |> handle_response()
  end

  def blob(client, account_id, image_id) do
    c(client)
    |> Tesla.get(image_path(account_id, image_id) <> "/blob")
    |> handle_response()
  end

  def create_direct_upload_v2(client, account_id, %Multipart{} = multipart) do
    c(client)
    |> Tesla.post("/accounts/#{account_id}/images/v2/direct_upload", multipart)
    |> handle_response()
  end

  defp v1_base(account_id), do: "/accounts/#{account_id}/images/v1"
  defp image_path(account_id, image_id), do: v1_base(account_id) <> "/#{image_id}"

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
