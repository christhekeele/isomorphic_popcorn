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
