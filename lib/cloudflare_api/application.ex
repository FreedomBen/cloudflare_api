defmodule CloudflareApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  use CloudflareApi.Typespecs

  use Application

  @impl true
  @spec start(Application.start_type(), term()) :: {:ok, pid()} | {:error, term()}
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: CloudflareApi.Worker.start_link(arg)
      # {CloudflareApi.Worker, arg}
      {CloudflareApi.Cache, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CloudflareApi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
