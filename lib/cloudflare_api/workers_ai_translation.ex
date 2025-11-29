defmodule CloudflareApi.WorkersAiTranslation do
  @moduledoc ~S"""
  Workers AI translation helpers.
  """

  @json_models [
    {:run_cf_ai4bharat_indictrans2_en_indic_1b, "@cf/ai4bharat/indictrans2-en-indic-1B"},
    {:run_cf_meta_m2m100_1_2b, "@cf/meta/m2m100-1.2b"}
  ]

  @doc false
  def run_models, do: @json_models

  for {fun, model} <- @json_models do
    @doc ~S"""
    Execute the #{model} model (`POST /accounts/:account_id/ai/run/#{model}`).
    """
    def unquote(fun)(client, account_id, body \\ %{}, opts \\ []) do
      post_run(client, account_id, unquote(model), body, opts)
    end
  end

  defp post_run(client, account_id, model, body, opts) do
    c(client)
    |> Tesla.post(with_query(run_path(account_id, model), opts), body)
    |> handle_response()
  end

  defp run_path(account_id, model), do: "/accounts/#{account_id}/ai/run/#{model}"

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
