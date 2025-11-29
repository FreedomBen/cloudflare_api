defmodule CloudflareApi.WorkersAiTextEmbeddings do
  @moduledoc ~S"""
  Workers AI text embedding helpers that wrap `/accounts/:account_id/ai/run/*`
  embedding models.
  """

  @json_models [
    {:run_cf_baai_bge_base_en_v1_5, "@cf/baai/bge-base-en-v1.5"},
    {:run_cf_baai_bge_large_en_v1_5, "@cf/baai/bge-large-en-v1.5"},
    {:run_cf_baai_bge_m3, "@cf/baai/bge-m3"},
    {:run_cf_baai_bge_small_en_v1_5, "@cf/baai/bge-small-en-v1.5"},
    {:run_cf_baai_omni_bge_base_en_v1_5, "@cf/baai/omni-bge-base-en-v1.5"},
    {:run_cf_baai_omni_bge_large_en_v1_5, "@cf/baai/omni-bge-large-en-v1.5"},
    {:run_cf_baai_omni_bge_m3, "@cf/baai/omni-bge-m3"},
    {:run_cf_baai_omni_bge_small_en_v1_5, "@cf/baai/omni-bge-small-en-v1.5"},
    {:run_cf_baai_ray_bge_large_en_v1_5, "@cf/baai/ray-bge-large-en-v1.5"},
    {:run_cf_google_embeddinggemma_300m, "@cf/google/embeddinggemma-300m"},
    {:run_cf_google_omni_embeddinggemma_300m, "@cf/google/omni-embeddinggemma-300m"},
    {:run_cf_pfnet_plamo_embedding_1b, "@cf/pfnet/plamo-embedding-1b"},
    {:run_cf_qwen_qwen3_embedding_0_6b, "@cf/qwen/qwen3-embedding-0.6b"}
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
