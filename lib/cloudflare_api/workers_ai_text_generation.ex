defmodule CloudflareApi.WorkersAiTextGeneration do
  @moduledoc ~S"""
  Workers AI text generation helpers for the large catalog of `/ai/run` models.
  """

  @json_models [
    {:run_cf_aisingapore_gemma_sea_lion_v4_27b_it, "@cf/aisingapore/gemma-sea-lion-v4-27b-it"},
    {:run_cf_deepseek_ai_deepseek_math_7b_instruct, "@cf/deepseek-ai/deepseek-math-7b-instruct"},
    {:run_cf_deepseek_ai_deepseek_r1_distill_qwen_32b,
     "@cf/deepseek-ai/deepseek-r1-distill-qwen-32b"},
    {:run_cf_defog_sqlcoder_7b_2, "@cf/defog/sqlcoder-7b-2"},
    {:run_cf_fblgit_una_cybertron_7b_v2_bf16, "@cf/fblgit/una-cybertron-7b-v2-bf16"},
    {:run_cf_google_gemma_2b_it_lora, "@cf/google/gemma-2b-it-lora"},
    {:run_cf_google_gemma_3_12b_it, "@cf/google/gemma-3-12b-it"},
    {:run_cf_google_gemma_7b_it_lora, "@cf/google/gemma-7b-it-lora"},
    {:run_cf_ibm_granite_granite_4_0_h_micro, "@cf/ibm-granite/granite-4.0-h-micro"},
    {:run_cf_meta_llama_llama_2_7b_chat_hf_lora, "@cf/meta-llama/llama-2-7b-chat-hf-lora"},
    {:run_cf_meta_llama_2_7b_chat_fp16, "@cf/meta/llama-2-7b-chat-fp16"},
    {:run_cf_meta_llama_2_7b_chat_int8, "@cf/meta/llama-2-7b-chat-int8"},
    {:run_cf_meta_llama_3_8b_instruct, "@cf/meta/llama-3-8b-instruct"},
    {:run_cf_meta_llama_3_8b_instruct_awq, "@cf/meta/llama-3-8b-instruct-awq"},
    {:run_cf_meta_llama_3_1_70b_instruct_fp8_fast, "@cf/meta/llama-3.1-70b-instruct-fp8-fast"},
    {:run_cf_meta_llama_3_1_8b_instruct_awq, "@cf/meta/llama-3.1-8b-instruct-awq"},
    {:run_cf_meta_llama_3_1_8b_instruct_fp8, "@cf/meta/llama-3.1-8b-instruct-fp8"},
    {:run_cf_meta_llama_3_1_8b_instruct_fp8_fast, "@cf/meta/llama-3.1-8b-instruct-fp8-fast"},
    {:run_cf_meta_llama_3_2_11b_vision_instruct, "@cf/meta/llama-3.2-11b-vision-instruct"},
    {:run_cf_meta_llama_3_2_1b_instruct, "@cf/meta/llama-3.2-1b-instruct"},
    {:run_cf_meta_llama_3_2_3b_instruct, "@cf/meta/llama-3.2-3b-instruct"},
    {:run_cf_meta_llama_3_3_70b_instruct_fp8_fast, "@cf/meta/llama-3.3-70b-instruct-fp8-fast"},
    {:run_cf_meta_llama_4_scout_17b_16e_instruct, "@cf/meta/llama-4-scout-17b-16e-instruct"},
    {:run_cf_meta_llama_guard_3_8b, "@cf/meta/llama-guard-3-8b"},
    {:run_cf_microsoft_phi_2, "@cf/microsoft/phi-2"},
    {:run_cf_mistral_mistral_7b_instruct_v0_1, "@cf/mistral/mistral-7b-instruct-v0.1"},
    {:run_cf_mistral_mistral_7b_instruct_v0_2_lora, "@cf/mistral/mistral-7b-instruct-v0.2-lora"},
    {:run_cf_mistralai_mistral_small_3_1_24b_instruct,
     "@cf/mistralai/mistral-small-3.1-24b-instruct"},
    {:run_cf_openai_gpt_oss_120b, "@cf/openai/gpt-oss-120b"},
    {:run_cf_openai_gpt_oss_20b, "@cf/openai/gpt-oss-20b"},
    {:run_cf_openchat_openchat_3_5_0106, "@cf/openchat/openchat-3.5-0106"},
    {:run_cf_qwen_qwen1_5_0_5b_chat, "@cf/qwen/qwen1.5-0.5b-chat"},
    {:run_cf_qwen_qwen1_5_1_8b_chat, "@cf/qwen/qwen1.5-1.8b-chat"},
    {:run_cf_qwen_qwen1_5_14b_chat_awq, "@cf/qwen/qwen1.5-14b-chat-awq"},
    {:run_cf_qwen_qwen1_5_7b_chat_awq, "@cf/qwen/qwen1.5-7b-chat-awq"},
    {:run_cf_qwen_qwen2_5_coder_32b_instruct, "@cf/qwen/qwen2.5-coder-32b-instruct"},
    {:run_cf_qwen_qwen3_30b_a3b_fp8, "@cf/qwen/qwen3-30b-a3b-fp8"},
    {:run_cf_qwen_qwq_32b, "@cf/qwen/qwq-32b"},
    {:run_cf_thebloke_discolm_german_7b_v1_awq, "@cf/thebloke/discolm-german-7b-v1-awq"},
    {:run_cf_tiiuae_falcon_7b_instruct, "@cf/tiiuae/falcon-7b-instruct"},
    {:run_cf_tinyllama_tinyllama_1_1b_chat_v1_0, "@cf/tinyllama/tinyllama-1.1b-chat-v1.0"},
    {:run_hf_google_gemma_7b_it, "@hf/google/gemma-7b-it"},
    {:run_hf_mistral_mistral_7b_instruct_v0_2, "@hf/mistral/mistral-7b-instruct-v0.2"},
    {:run_hf_nexusflow_starling_lm_7b_beta, "@hf/nexusflow/starling-lm-7b-beta"},
    {:run_hf_nousresearch_hermes_2_pro_mistral_7b, "@hf/nousresearch/hermes-2-pro-mistral-7b"},
    {:run_hf_thebloke_deepseek_coder_6_7b_base_awq, "@hf/thebloke/deepseek-coder-6.7b-base-awq"},
    {:run_hf_thebloke_deepseek_coder_6_7b_instruct_awq,
     "@hf/thebloke/deepseek-coder-6.7b-instruct-awq"},
    {:run_hf_thebloke_llama_2_13b_chat_awq, "@hf/thebloke/llama-2-13b-chat-awq"},
    {:run_hf_thebloke_llamaguard_7b_awq, "@hf/thebloke/llamaguard-7b-awq"},
    {:run_hf_thebloke_mistral_7b_instruct_v0_1_awq, "@hf/thebloke/mistral-7b-instruct-v0.1-awq"},
    {:run_hf_thebloke_neural_chat_7b_v3_1_awq, "@hf/thebloke/neural-chat-7b-v3-1-awq"},
    {:run_hf_thebloke_openhermes_2_5_mistral_7b_awq,
     "@hf/thebloke/openhermes-2.5-mistral-7b-awq"},
    {:run_hf_thebloke_zephyr_7b_beta_awq, "@hf/thebloke/zephyr-7b-beta-awq"}
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
