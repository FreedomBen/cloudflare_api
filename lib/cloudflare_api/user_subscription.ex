defmodule CloudflareApi.UserSubscription do
  @moduledoc ~S"""
  Manage user subscriptions via `/user/subscriptions`.
  """

  def list(client, opts \\ []) do
    c(client)
    |> Tesla.get(with_query("/user/subscriptions", opts))
    |> handle_response()
  end

  def update(client, subscription_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(subscription_path(subscription_id), params)
    |> handle_response()
  end

  def delete(client, subscription_id) do
    c(client)
    |> Tesla.delete(subscription_path(subscription_id), body: %{})
    |> handle_response()
  end

  defp subscription_path(identifier), do: "/user/subscriptions/#{encode(identifier)}"
  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

  defp with_query(path, []), do: path
  defp with_query(path, opts), do: path <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
