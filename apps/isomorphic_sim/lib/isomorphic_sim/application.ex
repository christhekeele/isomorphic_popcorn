defmodule IsomorphicSim.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @otp_app :isomorphic_sim
  def name, do: @otp_app

  @env Application.compile_env!(@otp_app, :env)
  def env, do: @env

  @target Application.compile_env!(@otp_app, :target)
  def target, do: @target

  @impl true
  def start(_type, _args) do
    if target() == :wasm do
      Popcorn.Wasm.register(__MODULE__)

      Popcorn.Wasm.run_js("""
      ({ wasm, args }) => {
        console.log("Starting simulation application in frontend...")
        return [];
      }
      """)
    else
      IO.puts("Starting simulation application in backend...")
    end

    children = [
      # Starts a worker by calling: IsomorphicSim.Worker.start_link(arg)
      # {IsomorphicSim.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: IsomorphicSim.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
