defmodule CloudflareApi.StreamLiveInputs do
  @moduledoc ~S"""
  Manage Stream live inputs and their outputs under `/accounts/:account_id/stream/live_inputs`.
  """

  @doc ~S"""
  List live inputs (`GET /stream/live_inputs`).
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base(account_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a live input (`POST /stream/live_inputs`).
  """
  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get a live input (`GET /stream/live_inputs/:id`).
  """
  def get(client, account_id, live_input_id) do
    c(client)
    |> Tesla.get(input_path(account_id, live_input_id))
    |> handle_response()
  end

  @doc ~S"""
  Update a live input (`PUT /stream/live_inputs/:id`).
  """
  def update(client, account_id, live_input_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(input_path(account_id, live_input_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a live input (`DELETE /stream/live_inputs/:id`).
  """
  def delete(client, account_id, live_input_id) do
    c(client)
    |> Tesla.delete(input_path(account_id, live_input_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  List outputs for a live input (`GET /stream/live_inputs/:id/outputs`).
  """
  def list_outputs(client, account_id, live_input_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(outputs_path(account_id, live_input_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create an output for a live input (`POST /stream/live_inputs/:id/outputs`).
  """
  def create_output(client, account_id, live_input_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(outputs_path(account_id, live_input_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Update an output for a live input (`PUT /stream/live_inputs/:id/outputs/:output_id`).
  """
  def update_output(client, account_id, live_input_id, output_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(output_path(account_id, live_input_id, output_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete an output for a live input (`DELETE /stream/live_inputs/:id/outputs/:output_id`).
  """
  def delete_output(client, account_id, live_input_id, output_id) do
    c(client)
    |> Tesla.delete(output_path(account_id, live_input_id, output_id), body: %{})
    |> handle_response()
  end

  defp base(account_id), do: "/accounts/#{account_id}/stream/live_inputs"

  defp input_path(account_id, live_input_id) do
    base(account_id) <> "/#{encode(live_input_id)}"
  end

  defp outputs_path(account_id, live_input_id) do
    input_path(account_id, live_input_id) <> "/outputs"
  end

  defp output_path(account_id, live_input_id, output_id) do
    outputs_path(account_id, live_input_id) <> "/#{encode(output_id)}"
  end

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
