defmodule IsomorphicSite.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @otp_app :isomorphic_site
  def name, do: @otp_app

  @env Application.compile_env!(@otp_app, :env)
  def env, do: @env

  @target Application.compile_env!(@otp_app, :target)
  def target, do: @target

  @impl true
  def start(_type, _args) do
    children = [
      IsomorphicSiteWeb.Telemetry,
      IsomorphicSite.Repo,
      {DNSCluster, query: Application.get_env(:isomorphic_site, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: IsomorphicSite.PubSub},
      # Start a worker by calling: IsomorphicSite.Worker.start_link(arg)
      # {IsomorphicSite.Worker, arg},
      # Start to serve requests, typically the last entry
      IsomorphicSiteWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: IsomorphicSite.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    IsomorphicSiteWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
