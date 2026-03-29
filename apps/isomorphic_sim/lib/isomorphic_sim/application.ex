defmodule IsomorphicSim.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @otp_app :isomorphic_sim
  def name, do: @otp_app

  @env Application.compile_env!(@otp_app, :env)
  def env, do: @env

  @known_envs Application.compile_env!(@otp_app, :known_envs)

  defmacro in_env(env) when env in @known_envs do
    quote generated: true do
      unquote(@env) == unquote(env)
    end
  end

  defmacro in_env(env) do
    raise CompileError,
      file: __CALLER__.file,
      line: __CALLER__.line,
      description: """
      unrecognized env: `#{inspect(env)}`,
      known envs: `#{inspect(@known_envs)}`
      (set in `Application.compile_env!(#{inspect(@otp_app)}, :known_envs)`)
      """
  end

  @target Application.compile_env!(@otp_app, :target)
  def target, do: @target

  @known_targets Application.compile_env!(@otp_app, :known_targets)

  defmacro is_targeting(target) when target in @known_targets do
    quote generated: true do
      unquote(@target) == unquote(target)
    end
  end

  defmacro is_targeting(target) do
    raise CompileError,
      file: __CALLER__.file,
      line: __CALLER__.line,
      description: """
      unrecognized target: `#{inspect(target)}`,
      known targets: `#{inspect(@known_targets)}`
      (set in `Application.compile_env!(#{inspect(@otp_app)}, :known_targets)`)
      """
  end

  @impl true
  def start(_type, _args) do
    if is_targeting(:wasm) do
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
