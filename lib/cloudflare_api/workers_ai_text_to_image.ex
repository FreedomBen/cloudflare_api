defmodule CloudflareApi.WorkersAiTextToImage do
  @moduledoc ~S"""
  Workers AI text-to-image helpers, covering POST runs and websocket/test pipe endpoints.
  """

  use CloudflareApi.Typespecs

  @json_models [
    {:run_cf_black_forest_labs_flux_1_schnell, "@cf/black-forest-labs/flux-1-schnell"},
    {:run_cf_bytedance_stable_diffusion_xl_lightning,
     "@cf/bytedance/stable-diffusion-xl-lightning"},
    {:run_cf_leonardo_lucid_origin, "@cf/leonardo/lucid-origin"},
    {:run_cf_leonardo_phoenix_1_0, "@cf/leonardo/phoenix-1.0"},
    {:run_cf_lykon_dreamshaper_8_lcm, "@cf/lykon/dreamshaper-8-lcm"},
    {:run_cf_runwayml_stable_diffusion_v1_5_img2img,
     "@cf/runwayml/stable-diffusion-v1-5-img2img"},
    {:run_cf_runwayml_stable_diffusion_v1_5_inpainting,
     "@cf/runwayml/stable-diffusion-v1-5-inpainting"},
    {:run_cf_stabilityai_stable_diffusion_xl_base_1_0,
     "@cf/stabilityai/stable-diffusion-xl-base-1.0"}
  ]

  @websocket_models [
    {:websocket_run_cf_sven_test_pipe_http, "@cf/sven/test-pipe-http"}
  ]

  @doc false
  def run_models, do: @json_models

  @doc false
  def websocket_models, do: @websocket_models

  for {fun, model} <- @json_models do
    @doc ~S"""
    Execute the #{model} model (`POST /accounts/:account_id/ai/run/#{model}`).
    """
    def unquote(fun)(client, account_id, body \\ %{}, opts \\ []) do
      post_run(client, account_id, unquote(model), body, opts)
    end
  end

  for {fun, model} <- @websocket_models do
    @doc ~S"""
    Open the websocket endpoint for #{model} (`GET /accounts/:account_id/ai/run/#{model}`).
    """
    def unquote(fun)(client, account_id) do
      c(client)
      |> Tesla.get(run_path(account_id, unquote(model)))
      |> handle_response()
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
