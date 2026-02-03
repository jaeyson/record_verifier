defmodule RecordVerifier.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RecordVerifierWeb.Telemetry,
      RecordVerifier.Repo,
      {DNSCluster, query: Application.get_env(:record_verifier, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: RecordVerifier.PubSub},
      # Start a worker by calling: RecordVerifier.Worker.start_link(arg)
      # {RecordVerifier.Worker, arg},
      # Start to serve requests, typically the last entry
      RecordVerifierWeb.Endpoint,
      {AshAuthentication.Supervisor, [otp_app: :record_verifier]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RecordVerifier.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RecordVerifierWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
