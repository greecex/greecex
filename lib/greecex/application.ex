defmodule Greecex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GreecexWeb.Telemetry,
      Greecex.Repo,
      {DNSCluster, query: Application.get_env(:greecex, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Greecex.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Greecex.Finch},
      # Start a worker by calling: Greecex.Worker.start_link(arg)
      # {Greecex.Worker, arg},
      # Start to serve requests, typically the last entry
      GreecexWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Greecex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GreecexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
