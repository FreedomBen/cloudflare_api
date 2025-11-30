defmodule CloudflareApi.WorkersAiTextClassification do
  @moduledoc ~S"""
  Workers AI text classification helpers.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Execute BAAI BGE Reranker Base
  (`POST /accounts/:account_id/ai/run/@cf/baai/bge-reranker-base`).
  """
  def run_cf_baai_bge_reranker_base(client, account_id, body \\ %{}, opts \\ []) do
    post_run(client, account_id, "@cf/baai/bge-reranker-base", body, opts)
  end

  @doc ~S"""
  Execute HuggingFace DistilBERT SST-2 Int8
  (`POST .../@cf/huggingface/distilbert-sst-2-int8`).
  """
  def run_cf_huggingface_distilbert_sst2_int8(client, account_id, body \\ %{}, opts \\ []) do
    post_run(client, account_id, "@cf/huggingface/distilbert-sst-2-int8", body, opts)
  end

  @doc ~S"""
  Execute HuggingFace Omni DistilBERT SST-2 Int8
  (`POST .../@cf/huggingface/omni-distilbert-sst-2-int8`).
  """
  def run_cf_huggingface_omni_distilbert_sst2_int8(client, account_id, body \\ %{}, opts \\ []) do
    post_run(client, account_id, "@cf/huggingface/omni-distilbert-sst-2-int8", body, opts)
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
